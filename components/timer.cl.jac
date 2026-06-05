import from .ui.card { Card, CardHeader, CardTitle, CardDescription, CardContent }
import from .ui.button { Button }
import from .ui.badge { Badge }
cl import from "@hugeicons/react" { HugeiconsIcon }
cl import from "@hugeicons/core-free-icons" { PlayIcon, PauseIcon, RefreshIcon, Timer01Icon }

glob PRESETS: list = [
    {"name": "Prepared Speech", "sub": "5–7 min", "green": 300, "yellow": 360, "red": 420},
    {"name": "Table Topics", "sub": "1–2 min", "green": 60, "yellow": 90, "red": 120},
    {"name": "Evaluation", "sub": "2–3 min", "green": 120, "yellow": 150, "red": 180},
    {"name": "Ice Breaker", "sub": "4–6 min", "green": 240, "yellow": 300, "red": 360},
    {"name": "Custom", "sub": "No limits", "green": 0, "yellow": 0, "red": 0}
];

glob counter_ref: dict = {"value": 0};

def:pub Timer() -> JsxElement {
    has elapsed: int = 0;
    has is_running: bool = False;
    has interval_id: any = None;
    has selected_preset: int = 0;

    counter_ref["value"] = elapsed;

    preset: any = PRESETS[selected_preset];
    green_time: any = preset["green"];
    yellow_time: any = preset["yellow"];
    red_time: any = preset["red"];

    current_color: str = "none";
    if elapsed >= red_time and red_time > 0 {
        current_color = "red";
    } elif elapsed >= yellow_time and yellow_time > 0 {
        current_color = "yellow";
    } elif elapsed >= green_time and green_time > 0 {
        current_color = "green";
    }

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
                clearInterval(int(interval_id));
                interval_id = None;
            }
        }
    }

    def handle_reset(e: MouseEvent) -> None {
        is_running = False;
        if interval_id {
            clearInterval(int(interval_id));
            interval_id = None;
        }
        counter_ref["value"] = 0;
        elapsed = 0;
    }

    def handle_preset(idx: int) -> None {
        selected_preset = idx;
        counter_ref["value"] = 0;
        elapsed = 0;
        is_running = False;
        if interval_id {
            clearInterval(int(interval_id));
            interval_id = None;
        }
    }

    gt: int = int(green_time);
    yt: int = int(yellow_time);
    rt: int = int(red_time);
    green_display: str = str(gt // 60).zfill(2) + ":" + str(gt % 60).zfill(2);
    yellow_display: str = str(yt // 60).zfill(2) + ":" + str(yt % 60).zfill(2);
    red_display: str = str(rt // 60).zfill(2) + ":" + str(rt % 60).zfill(2);

    timer_bg: str = "from-primary/5 to-primary/10";
    timer_border: str = "border-primary/20";
    timer_text: str = "text-foreground";
    glow: str = "";
    if current_color == "green" {
        timer_bg = "from-green-500/20 to-green-600/30";
        timer_border = "border-green-500/40";
        timer_text = "text-green-700";
        glow = "shadow-green-500/30";
    } elif current_color == "yellow" {
        timer_bg = "from-amber-400/20 to-amber-500/30";
        timer_border = "border-amber-400/40";
        timer_text = "text-amber-700";
        glow = "shadow-amber-400/30";
    } elif current_color == "red" {
        timer_bg = "from-red-500/20 to-red-600/30";
        timer_border = "border-red-500/40";
        timer_text = "text-red-700";
        glow = "shadow-red-500/30";
    }

    green_active: str = "bg-green-500 shadow-lg shadow-green-500/60 scale-125" if current_color == "green" else "bg-green-500/20 border-2 border-green-500/30";
    yellow_active: str = "bg-amber-400 shadow-lg shadow-amber-400/60 scale-125" if current_color == "yellow" else "bg-amber-400/20 border-2 border-amber-400/30";
    red_active: str = "bg-red-500 shadow-lg shadow-red-500/60 scale-125" if current_color == "red" else "bg-red-500/20 border-2 border-red-500/30";

    return <div className="min-h-screen bg-background">
        <div className="relative overflow-hidden hero-gradient px-6 py-10 md:py-14">
            <div className="absolute inset-0 opacity-10">
                <div className="absolute top-4 right-10 size-32 rounded-full bg-blue-400/30 blur-2xl"></div>
                <div className="absolute bottom-0 left-20 size-24 rounded-full bg-white/20 blur-xl"></div>
            </div>
            <div className="relative max-w-2xl mx-auto flex items-center gap-4">
                <div className="size-12 rounded-2xl bg-blue-500 flex items-center justify-center text-white shadow-lg shadow-blue-500/40">
                    <HugeiconsIcon icon={Timer01Icon} strokeWidth={1.5} className="size-6" />
                </div>
                <div>
                    <h1 className="text-2xl font-bold text-white">Speech Timer</h1>
                    <p className="text-white/60 text-sm">Track speech times with visual light signals</p>
                </div>
            </div>
        </div>

        <div className="max-w-2xl mx-auto px-4 py-8 flex flex-col gap-6">
            <div>
                <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-3">Speech Type</p>
                <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-2">
                    {[<button
                        key={str(i)}
                        onClick={lambda(e: MouseEvent) -> None { handle_preset(i); }}
                        className={"p-3 rounded-xl border text-left transition-all duration-200 " + ("bg-primary text-primary-foreground border-primary shadow-md shadow-primary/30" if selected_preset == i else "bg-card border-border hover:border-primary/40 hover:bg-primary/5")}
                    >
                        <div className={"text-xs font-bold " + ("text-primary-foreground" if selected_preset == i else "text-foreground")}>
                            {str(PRESETS[i]["name"])}
                        </div>
                        <div className={"text-xs mt-0.5 " + ("text-primary-foreground/70" if selected_preset == i else "text-muted-foreground")}>
                            {str(PRESETS[i]["sub"])}
                        </div>
                    </button> for i in range(len(PRESETS))]}
                </div>
                {gt > 0 and <div className="flex items-center gap-3 mt-3 px-1">
                    <div className="flex items-center gap-1.5 text-xs text-muted-foreground">
                        <span className="size-2.5 rounded-full bg-green-500 inline-block"></span>
                        <span className="font-medium text-foreground">{green_display}</span>
                    </div>
                    <span className="text-border">·</span>
                    <div className="flex items-center gap-1.5 text-xs text-muted-foreground">
                        <span className="size-2.5 rounded-full bg-amber-400 inline-block"></span>
                        <span className="font-medium text-foreground">{yellow_display}</span>
                    </div>
                    <span className="text-border">·</span>
                    <div className="flex items-center gap-1.5 text-xs text-muted-foreground">
                        <span className="size-2.5 rounded-full bg-red-500 inline-block"></span>
                        <span className="font-medium text-foreground">{red_display}</span>
                    </div>
                </div>}
            </div>

            <div className={"relative rounded-3xl border-2 bg-gradient-to-br p-10 text-center transition-all duration-700 shadow-xl " + timer_bg + " " + timer_border + " " + glow}>
                <div className="absolute top-0 left-0 right-0 flex justify-center -translate-y-1/2">
                    <div className="flex items-center gap-4 bg-card rounded-full px-6 py-2 border border-border shadow-sm">
                        <div className={"size-4 rounded-full transition-all duration-500 " + green_active}></div>
                        <div className={"size-4 rounded-full transition-all duration-500 " + yellow_active}></div>
                        <div className={"size-4 rounded-full transition-all duration-500 " + red_active}></div>
                    </div>
                </div>

                <div className={"font-mono text-8xl md:text-9xl font-black tracking-wider tabular-nums mt-4 transition-colors duration-500 " + timer_text}>
                    {time_display}
                </div>

                <div className="mt-2 text-sm text-muted-foreground">
                    {is_running and <span className="flex items-center justify-center gap-1.5"><span className="size-1.5 rounded-full bg-green-500 animate-pulse"></span> Running</span>}
                    {not is_running and elapsed > 0 and <span>Paused</span>}
                    {not is_running and elapsed == 0 and <span>Ready to start</span>}
                </div>
            </div>

            <div className="flex justify-center gap-3">
                {not is_running and <button
                    onClick={handle_start}
                    className="flex items-center gap-2 px-8 py-3 bg-green-600 hover:bg-green-700 text-white rounded-xl font-semibold text-sm transition-colors shadow-lg shadow-green-600/30"
                >
                    <HugeiconsIcon icon={PlayIcon} strokeWidth={2} className="size-5" />
                    Start
                </button>}
                {is_running and <button
                    onClick={handle_pause}
                    className="flex items-center gap-2 px-8 py-3 bg-amber-500 hover:bg-amber-600 text-white rounded-xl font-semibold text-sm transition-colors shadow-lg shadow-amber-500/30"
                >
                    <HugeiconsIcon icon={PauseIcon} strokeWidth={2} className="size-5" />
                    Pause
                </button>}
                <button
                    onClick={handle_reset}
                    className="flex items-center gap-2 px-8 py-3 bg-card border border-border hover:bg-muted text-foreground rounded-xl font-semibold text-sm transition-colors"
                >
                    <HugeiconsIcon icon={RefreshIcon} strokeWidth={2} className="size-5" />
                    Reset
                </button>
            </div>

            <div className="grid grid-cols-3 gap-3">
                <div className="bg-card rounded-xl border border-border p-4 text-center">
                    <div className="size-3 rounded-full bg-green-500 mx-auto mb-2"></div>
                    <div className="text-xs font-semibold text-foreground">Green</div>
                    <div className="text-xs text-muted-foreground mt-0.5">Min time reached</div>
                </div>
                <div className="bg-card rounded-xl border border-border p-4 text-center">
                    <div className="size-3 rounded-full bg-amber-400 mx-auto mb-2"></div>
                    <div className="text-xs font-semibold text-foreground">Yellow</div>
                    <div className="text-xs text-muted-foreground mt-0.5">Start concluding</div>
                </div>
                <div className="bg-card rounded-xl border border-border p-4 text-center">
                    <div className="size-3 rounded-full bg-red-500 mx-auto mb-2"></div>
                    <div className="text-xs font-semibold text-foreground">Red</div>
                    <div className="text-xs text-muted-foreground mt-0.5">Time is up</div>
                </div>
            </div>
        </div>
    </div>;
}
