import from ..lib.utils { cn }

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

    return <div className="min-h-screen bg-background p-4 md:p-8">
        <div className="max-w-3xl mx-auto flex flex-col gap-6">
            <div className="text-center flex flex-col gap-2">
                <h1 className="text-3xl md:text-4xl font-bold text-foreground">🗣️ Table Topics</h1>
                <p className="text-muted-foreground">Track impromptu speakers and their times</p>
            </div>

            <div className="rounded-xl border border-border bg-card p-6">
                <h2 className="text-lg font-semibold mb-4">Add Speaker</h2>
                <div className="flex flex-col gap-3">
                    <input
                        type="text"
                        value={new_speaker}
                        onChange={handle_speaker_change}
                        onKeyDown={handle_key}
                        placeholder="Speaker name..."
                        className="w-full p-3 rounded-lg border border-input bg-background text-foreground text-base"
                    />
                    <input
                        type="text"
                        value={new_topic}
                        onChange={handle_topic_change}
                        placeholder="Topic / question (optional)..."
                        className="w-full p-3 rounded-lg border border-input bg-background text-foreground text-base"
                    />
                    <button
                        onClick={add_entry}
                        className="px-6 py-3 rounded-lg bg-primary text-primary-foreground font-semibold hover:opacity-90 transition-opacity"
                    >
                        + Add Speaker
                    </button>
                </div>
            </div>

            {active_timer >= 0 and <div className="rounded-xl border-2 border-primary bg-primary/5 p-6 text-center">
                <p className="text-sm text-muted-foreground mb-1">Now Speaking</p>
                <p className="text-xl font-bold mb-3">{str(entries[active_timer]["speaker"]) if active_timer < len(entries) else ""}</p>
                <div className="text-6xl font-mono font-bold text-primary mb-4">{live_display}</div>
                <div className="flex justify-center gap-3">
                    <div className={cn(["w-4 h-4 rounded-full", "bg-green-500" if timer_elapsed >= 60 else "bg-green-500/20"])}></div>
                    <div className={cn(["w-4 h-4 rounded-full", "bg-yellow-400" if timer_elapsed >= 90 else "bg-yellow-400/20"])}></div>
                    <div className={cn(["w-4 h-4 rounded-full", "bg-red-500" if timer_elapsed >= 120 else "bg-red-500/20"])}></div>
                </div>
                <p className="text-xs text-muted-foreground mt-2">🟢 1:00 &nbsp; 🟡 1:30 &nbsp; 🔴 2:00</p>
                <button
                    onClick={lambda(e: MouseEvent) -> None { stop_timer(active_timer); }}
                    className="mt-4 px-8 py-3 rounded-lg bg-destructive/10 text-destructive border border-destructive/30 font-semibold hover:bg-destructive/20 transition-colors"
                >
                    ⏹ Stop & Save
                </button>
            </div>}

            {not has_entries and <div className="rounded-xl border border-border bg-card p-12 text-center">
                <p className="text-4xl mb-3">🗣️</p>
                <p className="text-muted-foreground">No speakers yet. Add the first Table Topics speaker above.</p>
            </div>}

            {has_entries and <div className="rounded-xl border border-border bg-card p-6">
                <h2 className="text-lg font-semibold mb-4">{"Speakers (" + str(len(entries)) + ")"}</h2>
                <div className="flex flex-col gap-3">
                    {[<div key={str(i)} className={cn(["rounded-lg p-4 border transition-colors",
                        "border-primary bg-primary/5" if active_timer == i else "border-border bg-muted"
                    ])}>
                        <div className="flex items-start justify-between gap-3">
                            <div className="flex flex-col gap-1 flex-1">
                                <div className="flex items-center gap-2">
                                    <span className="font-semibold">{str(entries[i]["speaker"])}</span>
                                    {str(entries[i]["done"]) == "True" and <span className="text-xs px-2 py-0.5 rounded-full bg-green-500/10 text-green-600 font-medium">Done</span>}
                                    {active_timer == i and <span className="text-xs px-2 py-0.5 rounded-full bg-primary/10 text-primary font-medium">Speaking...</span>}
                                </div>
                                {str(entries[i]["topic"]) and <p className="text-sm text-muted-foreground">{"Topic: " + str(entries[i]["topic"])}</p>}
                                {str(entries[i]["done"]) == "True" and <p className="text-sm font-medium text-primary">{"Time: " + fmt(int(entries[i]["duration"]))}</p>}
                            </div>
                            <div className="flex items-center gap-2">
                                {active_timer != i and str(entries[i]["done"]) != "True" and <button
                                    onClick={lambda(e: MouseEvent) -> None { start_timer(i); }}
                                    className="px-3 py-1.5 rounded-lg bg-green-600 text-white text-sm font-medium hover:bg-green-700 transition-colors"
                                >
                                    ▶ Start
                                </button>}
                                <button
                                    onClick={lambda(e: MouseEvent) -> None { remove_entry(i); }}
                                    className="text-muted-foreground hover:text-destructive transition-colors"
                                >
                                    ✕
                                </button>
                            </div>
                        </div>
                    </div> for i in range(len(entries))]}
                </div>
            </div>}

            {has_entries and <div className="flex justify-center">
                <button
                    onClick={handle_reset}
                    className="px-6 py-3 rounded-lg border border-border bg-background hover:bg-muted text-foreground font-semibold transition-colors"
                >
                    🔄 Reset All
                </button>
            </div>}
        </div>
    </div>;
}
