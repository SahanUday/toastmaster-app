import from ..lib.utils { cn }

# Speech presets
glob PRESETS: list = [
    {"name": "Prepared Speech (5-7 min)", "green": 300, "yellow": 360, "red": 420},
    {"name": "Table Topics (1-2 min)", "green": 60, "yellow": 90, "red": 120},
    {"name": "Evaluation (2-3 min)", "green": 120, "yellow": 150, "red": 180},
    {"name": "Ice Breaker (4-6 min)", "green": 240, "yellow": 300, "red": 360},
    {"name": "Custom", "green": 0, "yellow": 0, "red": 0}
];

# Mutable ref to track counter - avoids stale closure issue
glob counter_ref: dict = {"value": 0};

def:pub Timer() -> JsxElement {
    has elapsed: int = 0;
    has is_running: bool = False;
    has interval_id: Any = None;
    has selected_preset: int = 0;

    # Sync counter_ref with elapsed on mount/update
    counter_ref["value"] = elapsed;

    # Get current preset thresholds
    preset: Any = PRESETS[selected_preset];
    green_time: Any = preset["green"];
    yellow_time: Any = preset["yellow"];
    red_time: Any = preset["red"];

    # Determine current color
    current_color: str = "none";
    if elapsed >= red_time and red_time > 0 {
        current_color = "red";
    } elif elapsed >= yellow_time and yellow_time > 0 {
        current_color = "yellow";
    } elif elapsed >= green_time and green_time > 0 {
        current_color = "green";
    }

    # Format time as MM:SS
    mins: int = elapsed // 60;
    secs: int = elapsed % 60;
    time_display: str = str(mins).zfill(2) + ":" + str(secs).zfill(2);

    def handle_start(e: MouseEvent) -> None {
        if not is_running {
            is_running = True;
            interval_id = setInterval(lambda -> None {
                counter_ref["value"] = counter_ref["value"] + 1;
                elapsed = int(counter_ref["value"]);
            }, 1000);
        }
    }

    def handle_pause(e: MouseEvent) -> None {
        if is_running {
            is_running = False;
            if interval_id {
                clearInterval(interval_id);
                interval_id = None;
            }
        }
    }

    def handle_reset(e: MouseEvent) -> None {
        is_running = False;
        if interval_id {
            clearInterval(interval_id);
            interval_id = None;
        }
        counter_ref["value"] = 0;
        elapsed = 0;
    }

    def handle_preset_change(e: ChangeEvent) -> None {
        selected_preset = int(e.target.value);
        counter_ref["value"] = 0;
        elapsed = 0;
        is_running = False;
        if interval_id {
            clearInterval(interval_id);
            interval_id = None;
        }
    }

    # Background color classes based on signal
    bg_class: str = "bg-card";
    if current_color == "green" {
        bg_class = "bg-green-500";
    } elif current_color == "yellow" {
        bg_class = "bg-yellow-400";
    } elif current_color == "red" {
        bg_class = "bg-red-500";
    }

    # Text color for timer display
    text_class: str = "text-white" if current_color != "none" else "text-foreground";

    # Signal light classes
    green_light_class: str = "bg-green-500 border-green-300 shadow-lg shadow-green-500/50" if current_color == "green" else "bg-green-500/20 border-green-500/30";
    yellow_light_class: str = "bg-yellow-400 border-yellow-200 shadow-lg shadow-yellow-400/50" if current_color == "yellow" else "bg-yellow-400/20 border-yellow-400/30";
    red_light_class: str = "bg-red-500 border-red-300 shadow-lg shadow-red-500/50" if current_color == "red" else "bg-red-500/20 border-red-500/30";

    # Format threshold times for display
    gt: int = int(green_time);
    yt: int = int(yellow_time);
    rt: int = int(red_time);
    g_mins: int = gt // 60;
    g_secs: int = gt % 60;
    green_display: str = str(g_mins).zfill(2) + ":" + str(g_secs).zfill(2);
    y_mins: int = yt // 60;
    y_secs: int = yt % 60;
    yellow_display: str = str(y_mins).zfill(2) + ":" + str(y_secs).zfill(2);
    r_mins: int = rt // 60;
    r_secs: int = rt % 60;
    red_display: str = str(r_mins).zfill(2) + ":" + str(r_secs).zfill(2);

    return <div className="min-h-screen bg-background p-4 md:p-8">
        <div className="max-w-2xl mx-auto flex flex-col gap-6">
            <div className="text-center flex flex-col gap-2">
                <h1 className="text-3xl md:text-4xl font-bold text-foreground">⏱️ Toastmasters Timer</h1>
                <p className="text-muted-foreground">Track speech times with visual signals</p>
            </div>

            <div className="rounded-xl border border-border bg-card p-6">
                <h2 className="text-lg font-semibold mb-4">Speech Type</h2>
                <select
                    value={str(selected_preset)}
                    onChange={handle_preset_change}
                    className="w-full p-3 rounded-lg border border-input bg-background text-foreground text-lg"
                >
                    {[<option key={str(i)} value={str(i)}>{PRESETS[i]["name"]}</option> for i in range(len(PRESETS))]}
                </select>
                {green_time > 0 and <div className="mt-4 flex flex-wrap gap-4 text-sm">
                    <span className="flex items-center gap-2">
                        <span className="w-4 h-4 rounded-full bg-green-500"></span>
                        {green_display}
                    </span>
                    <span className="flex items-center gap-2">
                        <span className="w-4 h-4 rounded-full bg-yellow-400"></span>
                        {yellow_display}
                    </span>
                    <span className="flex items-center gap-2">
                        <span className="w-4 h-4 rounded-full bg-red-500"></span>
                        {red_display}
                    </span>
                </div>}
            </div>

            <div className={cn(["rounded-xl border border-border p-8 transition-colors duration-300", bg_class])}>
                <div className={cn(["text-center font-mono text-8xl md:text-9xl font-bold tracking-wider", text_class])}>
                    {time_display}
                </div>
                <div className="flex justify-center gap-4 mt-8">
                    <div className={cn(["w-12 h-12 md:w-16 md:h-16 rounded-full border-4 transition-all", green_light_class])}></div>
                    <div className={cn(["w-12 h-12 md:w-16 md:h-16 rounded-full border-4 transition-all", yellow_light_class])}></div>
                    <div className={cn(["w-12 h-12 md:w-16 md:h-16 rounded-full border-4 transition-all", red_light_class])}></div>
                </div>
            </div>

            <div className="flex justify-center gap-4">
                {not is_running and <button
                    onClick={handle_start}
                    className="px-8 py-4 text-xl rounded-lg bg-green-600 hover:bg-green-700 text-white font-semibold transition-colors"
                >
                    ▶️ Start
                </button>}
                {is_running and <button
                    onClick={handle_pause}
                    className="px-8 py-4 text-xl rounded-lg bg-yellow-500 hover:bg-yellow-600 text-white font-semibold transition-colors"
                >
                    ⏸️ Pause
                </button>}
                <button
                    onClick={handle_reset}
                    className="px-8 py-4 text-xl rounded-lg border border-border bg-background hover:bg-muted text-foreground font-semibold transition-colors"
                >
                    🔄 Reset
                </button>
            </div>

            <div className="rounded-xl border border-border bg-card p-4">
                <div className="text-center text-sm text-muted-foreground flex flex-col gap-1">
                    <p><strong>🟢 Green:</strong> Minimum time reached — you can wrap up</p>
                    <p><strong>🟡 Yellow:</strong> Target time — start concluding</p>
                    <p><strong>🔴 Red:</strong> Maximum time — please stop</p>
                </div>
            </div>
        </div>
    </div>;
}
