import from ..lib.utils { cn }
import from .ui.card { Card, CardHeader, CardTitle, CardDescription, CardContent }
import from .ui.button { Button }
import from .ui.badge { Badge }
import from .ui.input { Input }
import from .ui.separator { Separator }
cl import from "@hugeicons/react" { HugeiconsIcon }
cl import from "@hugeicons/core-free-icons" { Mic01Icon, PlayIcon, StopIcon, Delete01Icon, RefreshIcon, UserAdd01Icon, CheckmarkCircle01Icon }

glob tt_ref: dict = {"entries": []};
glob tt_timer_ref: dict = {"value": 0};

def:pub TableTopics() -> JsxElement {
    has entries: list = [];
    has new_speaker: str = "";
    has new_topic: str = "";
    has active_timer: int = -1;
    has timer_elapsed: int = 0;
    has timer_interval: Any = None;

    def handle_speaker_change(e: ChangeEvent) -> None {
        new_speaker = e.target.value;
    }

    def handle_topic_change(e: ChangeEvent) -> None {
        new_topic = e.target.value;
    }

    def add_entry(e: MouseEvent) -> None {
        if new_speaker {
            entry: dict = {"speaker": new_speaker, "topic": new_topic, "duration": 0, "done": False};
            updated: list = entries + [entry];
            tt_ref["entries"] = updated;
            entries = updated;
            new_speaker = "";
            new_topic = "";
        }
    }

    def handle_key(e: KeyboardEvent) -> None {
        if e.key == "Enter" and new_speaker {
            entry: dict = {"speaker": new_speaker, "topic": new_topic, "duration": 0, "done": False};
            updated: list = entries + [entry];
            tt_ref["entries"] = updated;
            entries = updated;
            new_speaker = "";
            new_topic = "";
        }
    }

    def start_timer(idx: int) -> None {
        if timer_interval {
            clearInterval(timer_interval);
        }
        tt_timer_ref["value"] = 0;
        timer_elapsed = 0;
        active_timer = idx;
        new_id: Any = setInterval(lambda -> None {
            tt_timer_ref["value"] = tt_timer_ref["value"] + 1;
            timer_elapsed = int(tt_timer_ref["value"]);
        }, 1000);
        timer_interval = new_id;
    }

    def stop_timer(idx: int) -> None {
        if timer_interval {
            clearInterval(timer_interval);
            timer_interval = None;
        }
        dur: int = int(tt_timer_ref["value"]);
        updated: list = [];
        for i in range(len(entries)) {
            e: Any = entries[i];
            if i == idx {
                updated = updated + [{"speaker": e["speaker"], "topic": e["topic"], "duration": dur, "done": True}];
            } else {
                updated = updated + [e];
            }
        }
        tt_ref["entries"] = updated;
        entries = updated;
        active_timer = -1;
        timer_elapsed = 0;
        tt_timer_ref["value"] = 0;
    }

    def remove_entry(idx: int) -> None {
        if active_timer == idx {
            if timer_interval {
                clearInterval(timer_interval);
                timer_interval = None;
            }
            active_timer = -1;
        }
        updated: list = [];
        for i in range(len(entries)) {
            if i != idx {
                updated = updated + [entries[i]];
            }
        }
        tt_ref["entries"] = updated;
        entries = updated;
    }

    def handle_reset(e: MouseEvent) -> None {
        if timer_interval {
            clearInterval(timer_interval);
            timer_interval = None;
        }
        tt_ref["entries"] = [];
        entries = [];
        active_timer = -1;
        timer_elapsed = 0;
        tt_timer_ref["value"] = 0;
    }

    def fmt(secs: int) -> str {
        m: int = secs // 60;
        s: int = secs % 60;
        return str(m).zfill(2) + ":" + str(s).zfill(2);
    }

    has_entries: bool = len(entries) > 0;
    live_display: str = fmt(timer_elapsed);

    green_sig: str = "bg-green-500 shadow-green-500/50 shadow-lg" if timer_elapsed >= 60 else "bg-green-500/20";
    yellow_sig: str = "bg-yellow-400 shadow-yellow-400/50 shadow-lg" if timer_elapsed >= 90 else "bg-yellow-400/20";
    red_sig: str = "bg-red-500 shadow-red-500/50 shadow-lg" if timer_elapsed >= 120 else "bg-red-500/20";

    return <div className="min-h-screen bg-background p-4 md:p-8">
        <div className="max-w-3xl mx-auto flex flex-col gap-6">
            <div className="flex items-center gap-3">
                <div className="size-10 rounded-xl bg-primary/10 flex items-center justify-center">
                    <HugeiconsIcon icon={Mic01Icon} strokeWidth={1.5} className="size-5 text-primary" />
                </div>
                <div>
                    <h1 className="text-2xl font-bold text-foreground">Table Topics</h1>
                    <p className="text-sm text-muted-foreground">Track impromptu speakers and their times</p>
                </div>
            </div>

            <Card>
                <CardHeader>
                    <CardTitle>Add Speaker</CardTitle>
                    <CardDescription>Add each Table Topics speaker before they speak</CardDescription>
                </CardHeader>
                <CardContent className="flex flex-col gap-3">
                    <Input
                        value={new_speaker}
                        onChange={handle_speaker_change}
                        onKeyDown={handle_key}
                        placeholder="Speaker name..."
                    />
                    <Input
                        value={new_topic}
                        onChange={handle_topic_change}
                        placeholder="Topic / question (optional)..."
                    />
                    <Button onClick={add_entry} className="gap-2">
                        <HugeiconsIcon icon={UserAdd01Icon} strokeWidth={2} className="size-4" />
                        Add Speaker
                    </Button>
                </CardContent>
            </Card>

            {active_timer >= 0 and active_timer < len(entries) and <Card className="border-2 border-primary">
                <CardContent className="py-8 flex flex-col items-center gap-6">
                    <div className="flex flex-col items-center gap-1">
                        <Badge className="mb-1">Now Speaking</Badge>
                        <p className="text-xl font-bold">{str(entries[active_timer]["speaker"])}</p>
                        {str(entries[active_timer]["topic"]) and <p className="text-sm text-muted-foreground">{"Topic: " + str(entries[active_timer]["topic"])}</p>}
                    </div>
                    <div className="text-7xl font-mono font-bold text-primary tabular-nums">{live_display}</div>
                    <div className="flex items-center gap-5">
                        <div className={cn(["size-12 rounded-full transition-all duration-300", green_sig])}></div>
                        <div className={cn(["size-12 rounded-full transition-all duration-300", yellow_sig])}></div>
                        <div className={cn(["size-12 rounded-full transition-all duration-300", red_sig])}></div>
                    </div>
                    <p className="text-xs text-muted-foreground">🟢 1:00 &nbsp;·&nbsp; 🟡 1:30 &nbsp;·&nbsp; 🔴 2:00</p>
                    <Button
                        onClick={lambda(e: MouseEvent) -> None { stop_timer(active_timer); }}
                        variant="destructive"
                        className="gap-2 px-8"
                    >
                        <HugeiconsIcon icon={StopIcon} strokeWidth={2} className="size-4" />
                        Stop & Save
                    </Button>
                </CardContent>
            </Card>}

            {not has_entries and <Card>
                <CardContent className="py-16 text-center flex flex-col items-center gap-3">
                    <div className="size-16 rounded-2xl bg-muted flex items-center justify-center">
                        <HugeiconsIcon icon={Mic01Icon} strokeWidth={1} className="size-8 text-muted-foreground" />
                    </div>
                    <p className="font-medium text-muted-foreground">No speakers yet</p>
                    <p className="text-sm text-muted-foreground">Add the first Table Topics speaker above</p>
                </CardContent>
            </Card>}

            {has_entries and <Card>
                <CardHeader>
                    <CardTitle>{"Speakers (" + str(len(entries)) + ")"}</CardTitle>
                </CardHeader>
                <CardContent className="flex flex-col gap-3">
                    {[<div key={str(i)} className={cn(["rounded-xl p-4 border transition-colors",
                        "border-primary bg-primary/5" if active_timer == i else "border-border bg-muted/30"
                    ])}>
                        <div className="flex items-start justify-between gap-3">
                            <div className="flex flex-col gap-1 flex-1">
                                <div className="flex items-center gap-2 flex-wrap">
                                    <span className="font-semibold">{str(entries[i]["speaker"])}</span>
                                    {str(entries[i]["done"]) == "True" and <Badge variant="secondary" className="gap-1">
                                        <HugeiconsIcon icon={CheckmarkCircle01Icon} strokeWidth={2} className="size-3" />
                                        {fmt(int(entries[i]["duration"]))}
                                    </Badge>}
                                    {active_timer == i and <Badge>Speaking...</Badge>}
                                </div>
                                {str(entries[i]["topic"]) and <p className="text-sm text-muted-foreground">{"Topic: " + str(entries[i]["topic"])}</p>}
                            </div>
                            <div className="flex items-center gap-2">
                                {active_timer != i and str(entries[i]["done"]) != "True" and <Button
                                    size="sm"
                                    onClick={lambda(e: MouseEvent) -> None { start_timer(i); }}
                                    className="gap-1.5 bg-green-600 hover:bg-green-700 text-white"
                                >
                                    <HugeiconsIcon icon={PlayIcon} strokeWidth={2} className="size-3.5" />
                                    Start
                                </Button>}
                                <Button
                                    variant="ghost"
                                    size="icon-sm"
                                    onClick={lambda(e: MouseEvent) -> None { remove_entry(i); }}
                                    className="text-muted-foreground hover:text-destructive"
                                >
                                    <HugeiconsIcon icon={Delete01Icon} strokeWidth={2} className="size-4" />
                                </Button>
                            </div>
                        </div>
                    </div> for i in range(len(entries))]}
                </CardContent>
            </Card>}

            {has_entries and <div className="flex justify-center">
                <Button variant="outline" onClick={handle_reset} className="gap-2 text-destructive hover:text-destructive">
                    <HugeiconsIcon icon={RefreshIcon} strokeWidth={2} className="size-4" />
                    Reset All
                </Button>
            </div>}
        </div>
    </div>;
}
