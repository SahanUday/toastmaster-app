import from ..lib.utils { cn }
import from .ui.card { Card, CardHeader, CardTitle, CardDescription, CardContent }
import from .ui.button { Button }
import from .ui.badge { Badge }
import from .ui.separator { Separator }
cl import from "@hugeicons/react" { HugeiconsIcon }
cl import from "@hugeicons/core-free-icons" { PlayIcon, PauseIcon, RefreshIcon, Timer01Icon }

glob PRESETS: list = [
    {"name": "Prepared Speech (5-7 min)", "green": 300, "yellow": 360, "red": 420},
    {"name": "Table Topics (1-2 min)", "green": 60, "yellow": 90, "red": 120},
    {"name": "Evaluation (2-3 min)", "green": 120, "yellow": 150, "red": 180},
    {"name": "Ice Breaker (4-6 min)", "green": 240, "yellow": 300, "red": 360},
    {"name": "Custom", "green": 0, "yellow": 0, "red": 0}
];

glob counter_ref: dict = {"value": 0};

def:pub Timer() -> JsxElement {
    has elapsed: int = 0;
    has is_running: bool = False;
    has interval_id: Any = None;
    has selected_preset: int = 0;

    counter_ref["value"] = elapsed;

    preset: Any = PRESETS[selected_preset];
    green_time: Any = preset["green"];
    yellow_time: Any = preset["yellow"];
    red_time: Any = preset["red"];

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

    bg_class: str = "bg-card";
    timer_text_class: str = "text-foreground";
    if current_color == "green" {
        bg_class = "bg-green-500";
        timer_text_class = "text-white";
    } elif current_color == "yellow" {
        bg_class = "bg-yellow-400";
        timer_text_class = "text-white";
    } elif current_color == "red" {
        bg_class = "bg-red-500";
        timer_text_class = "text-white";
    }

    green_light_class: str = "bg-green-500 shadow-lg shadow-green-500/50 scale-110" if current_color == "green" else "bg-green-500/20";
    yellow_light_class: str = "bg-yellow-400 shadow-lg shadow-yellow-400/50 scale-110" if current_color == "yellow" else "bg-yellow-400/20";
    red_light_class: str = "bg-red-500 shadow-lg shadow-red-500/50 scale-110" if current_color == "red" else "bg-red-500/20";

    gt: int = int(green_time);
    yt: int = int(yellow_time);
    rt: int = int(red_time);
    green_display: str = str(gt // 60).zfill(2) + ":" + str(gt % 60).zfill(2);
    yellow_display: str = str(yt // 60).zfill(2) + ":" + str(yt % 60).zfill(2);
    red_display: str = str(rt // 60).zfill(2) + ":" + str(rt % 60).zfill(2);

    return <div className="min-h-screen bg-background p-4 md:p-8">
        <div className="max-w-2xl mx-auto flex flex-col gap-6">
            <div className="flex items-center gap-3">
                <div className="size-10 rounded-xl bg-primary/10 flex items-center justify-center">
                    <HugeiconsIcon icon={Timer01Icon} strokeWidth={1.5} className="size-5 text-primary" />
                </div>
                <div>
                    <h1 className="text-2xl font-bold text-foreground">Speech Timer</h1>
                    <p className="text-sm text-muted-foreground">Track speech times with visual signals</p>
                </div>
            </div>

            <Card>
                <CardHeader>
                    <CardTitle>Speech Type</CardTitle>
                    <CardDescription>Select a preset to set the signal thresholds</CardDescription>
                </CardHeader>
                <CardContent className="flex flex-col gap-4">
                    <select
                        value={str(selected_preset)}
                        onChange={handle_preset_change}
                        className="w-full p-3 rounded-lg border border-input bg-background text-foreground text-base focus:outline-none focus:ring-2 focus:ring-ring"
                    >
                        {[<option key={str(i)} value={str(i)}>{PRESETS[i]["name"]}</option> for i in range(len(PRESETS))]}
                    </select>
                    {gt > 0 and <div className="flex flex-wrap gap-3">
                        <Badge variant="outline" className="gap-1.5 px-3 py-1">
                            <span className="size-2 rounded-full bg-green-500 inline-block"></span>
                            {green_display}
                        </Badge>
                        <Badge variant="outline" className="gap-1.5 px-3 py-1">
                            <span className="size-2 rounded-full bg-yellow-400 inline-block"></span>
                            {yellow_display}
                        </Badge>
                        <Badge variant="outline" className="gap-1.5 px-3 py-1">
                            <span className="size-2 rounded-full bg-red-500 inline-block"></span>
                            {red_display}
                        </Badge>
                    </div>}
                </CardContent>
            </Card>

            <Card className={cn(["transition-all duration-500", bg_class])}>
                <CardContent className="py-12 flex flex-col items-center gap-8">
                    <div className={cn(["font-mono text-8xl md:text-9xl font-bold tracking-wider tabular-nums", timer_text_class])}>
                        {time_display}
                    </div>
                    <div className="flex items-center gap-6">
                        <div className={cn(["size-14 rounded-full border-2 border-green-500/30 transition-all duration-300", green_light_class])}></div>
                        <div className={cn(["size-14 rounded-full border-2 border-yellow-400/30 transition-all duration-300", yellow_light_class])}></div>
                        <div className={cn(["size-14 rounded-full border-2 border-red-500/30 transition-all duration-300", red_light_class])}></div>
                    </div>
                </CardContent>
            </Card>

            <div className="flex justify-center gap-3">
                {not is_running and <Button
                    onClick={handle_start}
                    size="lg"
                    className="gap-2 px-8 bg-green-600 hover:bg-green-700 text-white"
                >
                    <HugeiconsIcon icon={PlayIcon} strokeWidth={2} className="size-5" />
                    Start
                </Button>}
                {is_running and <Button
                    onClick={handle_pause}
                    size="lg"
                    className="gap-2 px-8 bg-yellow-500 hover:bg-yellow-600 text-white"
                >
                    <HugeiconsIcon icon={PauseIcon} strokeWidth={2} className="size-5" />
                    Pause
                </Button>}
                <Button
                    onClick={handle_reset}
                    variant="outline"
                    size="lg"
                    className="gap-2 px-8"
                >
                    <HugeiconsIcon icon={RefreshIcon} strokeWidth={2} className="size-5" />
                    Reset
                </Button>
            </div>

            <Card>
                <CardContent className="py-4">
                    <div className="flex flex-col gap-2 text-sm text-muted-foreground text-center">
                        <p><span className="font-medium text-foreground">🟢 Green</span> — Minimum time reached, you can wrap up</p>
                        <p><span className="font-medium text-foreground">🟡 Yellow</span> — Target time, start concluding</p>
                        <p><span className="font-medium text-foreground">🔴 Red</span> — Maximum time, please stop</p>
                    </div>
                </CardContent>
            </Card>
        </div>
    </div>;
}
