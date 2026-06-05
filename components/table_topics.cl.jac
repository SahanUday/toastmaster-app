import from .ui.card { Card, CardContent }
import from .ui.button { Button }
import from .ui.badge { Badge }
import from .ui.input { Input }
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
    has timer_interval: any = None;

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
            clearInterval(int(timer_interval));
        }
        tt_timer_ref["value"] = 0;
        timer_elapsed = 0;
        active_timer = idx;
        new_id: any = setInterval(lambda -> None {
            tt_timer_ref["value"] = tt_timer_ref["value"] + 1;
            timer_elapsed = int(tt_timer_ref["value"]);
        }, 1000);
        timer_interval = new_id;
    }

    def stop_timer(idx: int) -> None {
        if timer_interval {
            clearInterval(int(timer_interval));
            timer_interval = None;
        }
        dur: int = int(tt_timer_ref["value"]);
        updated: list = [];
        for i in range(len(entries)) {
            e: any = entries[i];
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
                clearInterval(int(timer_interval));
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
            clearInterval(int(timer_interval));
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

    green_sig: str = "bg-green-500 shadow-green-500/60 shadow-xl scale-110" if timer_elapsed >= 60 else "bg-green-500/20 border-2 border-green-500/30";
    yellow_sig: str = "bg-amber-400 shadow-amber-400/60 shadow-xl scale-110" if timer_elapsed >= 90 else "bg-amber-400/20 border-2 border-amber-400/30";
    red_sig: str = "bg-red-500 shadow-red-500/60 shadow-xl scale-110" if timer_elapsed >= 120 else "bg-red-500/20 border-2 border-red-500/30";

    return <div className="min-h-screen bg-background">
        <div className="relative overflow-hidden hero-gradient px-6 py-10 md:py-14">
            <div className="absolute inset-0 opacity-10">
                <div className="absolute top-4 right-10 size-32 rounded-full bg-rose-400/30 blur-2xl"></div>
            </div>
            <div className="relative max-w-3xl mx-auto flex items-center gap-4">
                <div className="size-12 rounded-2xl bg-rose-500 flex items-center justify-center text-white shadow-lg shadow-rose-500/40">
                    <HugeiconsIcon icon={Mic01Icon} strokeWidth={1.5} className="size-6" />
                </div>
                <div>
                    <h1 className="text-2xl font-bold text-white">Table Topics</h1>
                    <p className="text-white/60 text-sm">Track impromptu speakers and their times</p>
                </div>
                {has_entries and <div className="ml-auto flex items-center gap-2 bg-white/10 border border-white/20 rounded-xl px-3 py-1.5">
                    <span className="text-white/70 text-xs">Speakers:</span>
                    <span className="text-white font-bold text-sm">{str(len(entries))}</span>
                </div>}
            </div>
        </div>

        <div className="max-w-3xl mx-auto px-4 py-8 flex flex-col gap-6">
            <div className="bg-card rounded-2xl border border-border p-5 shadow-sm">
                <h3 className="font-semibold text-sm text-foreground mb-3">Add Speaker</h3>
                <div className="flex flex-col gap-3">
                    <div className="flex gap-3">
                        <Input
                            value={new_speaker}
                            onChange={handle_speaker_change}
                            onKeyDown={handle_key}
                            placeholder="Speaker name..."
                            className="flex-1"
                        />
                        <button
                            onClick={add_entry}
                            className="flex items-center gap-2 px-4 py-2 bg-primary text-primary-foreground rounded-xl font-semibold text-sm hover:bg-primary/90 transition-colors shadow-sm"
                        >
                            <HugeiconsIcon icon={UserAdd01Icon} strokeWidth={2} className="size-4" />
                            Add
                        </button>
                    </div>
                    <Input
                        value={new_topic}
                        onChange={handle_topic_change}
                        placeholder="Topic / question (optional)..."
                    />
                </div>
            </div>

            {active_timer >= 0 and active_timer < len(entries) and <div className="relative overflow-hidden rounded-2xl border-2 border-primary/30 bg-gradient-to-br from-primary/5 to-primary/10 p-6 text-center">
                <div className="absolute top-0 right-0 w-32 h-32 bg-primary/5 rounded-full -translate-y-1/2 translate-x-1/4"></div>
                <div className="relative flex flex-col items-center gap-5">
                    <div className="flex flex-col items-center gap-1">
                        <span className="text-xs font-semibold text-primary uppercase tracking-widest bg-primary/10 px-3 py-1 rounded-full">Now Speaking</span>
                        <p className="text-2xl font-bold text-foreground mt-2">{str(entries[active_timer]["speaker"])}</p>
                        {str(entries[active_timer]["topic"]) and <p className="text-sm text-muted-foreground">{"Topic: " + str(entries[active_timer]["topic"])}</p>}
                    </div>
                    <div className="font-mono text-7xl font-black text-primary tabular-nums">{live_display}</div>
                    <div className="flex items-center gap-6">
                        <div className={cn(["size-12 rounded-full transition-all duration-500", green_sig])}></div>
                        <div className={cn(["size-12 rounded-full transition-all duration-500", yellow_sig])}></div>
                        <div className={cn(["size-12 rounded-full transition-all duration-500", red_sig])}></div>
                    </div>
                    <p className="text-xs text-muted-foreground">🟢 1:00 &nbsp;·&nbsp; 🟡 1:30 &nbsp;·&nbsp; 🔴 2:00</p>
                    <button
                        onClick={lambda(e: MouseEvent) -> None { stop_timer(active_timer); }}
                        className="flex items-center gap-2 px-8 py-3 bg-red-600 hover:bg-red-700 text-white rounded-xl font-semibold text-sm transition-colors shadow-lg shadow-red-600/30"
                    >
                        <HugeiconsIcon icon={StopIcon} strokeWidth={2} className="size-5" />
                        Stop & Save Time
                    </button>
                </div>
            </div>}

            {not has_entries and <div className="bg-card rounded-2xl border border-dashed border-border p-16 text-center flex flex-col items-center gap-3">
                <div className="size-16 rounded-2xl bg-rose-500/10 flex items-center justify-center">
                    <HugeiconsIcon icon={Mic01Icon} strokeWidth={1} className="size-8 text-rose-500" />
                </div>
                <p className="font-semibold text-foreground">No speakers yet</p>
                <p className="text-sm text-muted-foreground">Add the first Table Topics speaker above</p>
            </div>}

            {has_entries and <div className="bg-card rounded-2xl border border-border shadow-sm overflow-hidden">
                <div className="px-5 py-4 border-b border-border bg-muted/30 flex items-center justify-between">
                    <h3 className="font-semibold text-foreground">{"Speakers (" + str(len(entries)) + ")"}</h3>
                    <div className="flex items-center gap-2 text-xs text-muted-foreground">
                        <span className="size-2 rounded-full bg-green-500 inline-block"></span>Done
                    </div>
                </div>
                <div className="p-4 flex flex-col gap-3">
                    {[<div key={str(i)} className={"rounded-xl p-4 border transition-all duration-200 " + ("border-primary/40 bg-primary/5 shadow-sm" if active_timer == i else "border-green-500/30 bg-green-50" if str(entries[i]["done"]) == "True" else "border-border bg-muted/20")}>
                        <div className="flex items-start justify-between gap-3">
                            <div className="flex items-start gap-3 flex-1">
                                <div className={"size-9 rounded-full flex items-center justify-center font-bold text-sm text-white shrink-0 " + ("bg-primary" if active_timer == i else "bg-green-500" if str(entries[i]["done"]) == "True" else "bg-muted-foreground/50")}>
                                    {str(entries[i]["speaker"])[0].upper()}
                                </div>
                                <div className="flex flex-col gap-0.5">
                                    <div className="flex items-center gap-2 flex-wrap">
                                        <span className="font-semibold text-sm text-foreground">{str(entries[i]["speaker"])}</span>
                                        {str(entries[i]["done"]) == "True" and <span className="flex items-center gap-1 text-xs font-semibold text-green-700 bg-green-100 border border-green-200 px-2 py-0.5 rounded-full">
                                            <HugeiconsIcon icon={CheckmarkCircle01Icon} strokeWidth={2} className="size-3" />
                                            {fmt(int(entries[i]["duration"]))}
                                        </span>}
                                        {active_timer == i and <span className="flex items-center gap-1 text-xs font-semibold text-primary bg-primary/10 border border-primary/20 px-2 py-0.5 rounded-full">
                                            <span className="size-1.5 rounded-full bg-primary animate-pulse"></span>
                                            Speaking...
                                        </span>}
                                    </div>
                                    {str(entries[i]["topic"]) and <p className="text-xs text-muted-foreground">{"Topic: " + str(entries[i]["topic"])}</p>}
                                </div>
                            </div>
                            <div className="flex items-center gap-2">
                                {active_timer != i and str(entries[i]["done"]) != "True" and <button
                                    onClick={lambda(e: MouseEvent) -> None { start_timer(i); }}
                                    className="flex items-center gap-1.5 px-3 py-1.5 bg-green-600 hover:bg-green-700 text-white rounded-lg text-xs font-semibold transition-colors"
                                >
                                    <HugeiconsIcon icon={PlayIcon} strokeWidth={2} className="size-3.5" />
                                    Start
                                </button>}
                                <button
                                    onClick={lambda(e: MouseEvent) -> None { remove_entry(i); }}
                                    className="size-7 rounded-lg flex items-center justify-center text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors"
                                >
                                    <HugeiconsIcon icon={Delete01Icon} strokeWidth={2} className="size-3.5" />
                                </button>
                            </div>
                        </div>
                    </div> for i in range(len(entries))]}
                </div>
            </div>}

            {has_entries and <div className="flex justify-center">
                <button
                    onClick={handle_reset}
                    className="flex items-center gap-2 px-5 py-2.5 bg-card border border-destructive/30 hover:bg-destructive/5 text-destructive rounded-xl font-semibold text-sm transition-colors"
                >
                    <HugeiconsIcon icon={RefreshIcon} strokeWidth={2} className="size-4" />
                    Reset All
                </button>
            </div>}
        </div>
    </div>;
}
