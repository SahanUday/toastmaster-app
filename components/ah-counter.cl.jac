import from ..lib.utils { cn }

glob FILLER_WORDS: list = ["Um", "Ah", "Like", "You know", "So", "Basically", "Actually", "Right", "Okay"];

glob ah_ref: dict = {"speakers": []};

def:pub AhCounter() -> JsxElement {
    has speakers: list = [];
    has new_name: str = "";
    has show_report: bool = False;

    def handle_name_change(e: ChangeEvent) -> None {
        new_name = e.target.value;
    }

    def do_add_speaker() -> None {
        if new_name {
            counts: dict = {};
            for i in range(len(FILLER_WORDS)) {
                counts[FILLER_WORDS[i]] = 0;
            }
            speaker: dict = {"name": new_name, "counts": counts};
            updated: list = speakers + [speaker];
            ah_ref["speakers"] = updated;
            speakers = updated;
            new_name = "";
        }
    }

    def handle_add(e: MouseEvent) -> None {
        do_add_speaker();
    }

    def handle_key_down(e: KeyboardEvent) -> None {
        if e.key == "Enter" {
            do_add_speaker();
        }
    }

    def handle_increment(speaker_idx: int, word: str) -> None {
        updated: list = [];
        for i in range(len(speakers)) {
            s: Any = speakers[i];
            if i == speaker_idx {
                new_counts: dict = {};
                for j in range(len(FILLER_WORDS)) {
                    w: Any = FILLER_WORDS[j];
                    new_counts[w] = int(s["counts"][w]);
                }
                new_counts[word] = int(new_counts[word]) + 1;
                updated = updated + [{"name": s["name"], "counts": new_counts}];
            } else {
                updated = updated + [s];
            }
        }
        ah_ref["speakers"] = updated;
        speakers = updated;
    }

    def handle_remove(idx: int) -> None {
        updated: list = [];
        for i in range(len(speakers)) {
            if i != idx {
                updated = updated + [speakers[i]];
            }
        }
        ah_ref["speakers"] = updated;
        speakers = updated;
    }

    def handle_reset(e: MouseEvent) -> None {
        ah_ref["speakers"] = [];
        speakers = [];
        show_report = False;
    }

    def handle_toggle_report(e: MouseEvent) -> None {
        show_report = not show_report;
    }

    def get_total(s: Any) -> int {
        total: int = 0;
        for i in range(len(FILLER_WORDS)) {
            total = total + int(s["counts"][FILLER_WORDS[i]]);
        }
        return total;
    }

    has_speakers: bool = len(speakers) > 0;
    report_btn_label: str = "📊 Hide Report" if show_report else "📊 Show Report";

    return <div className="min-h-screen bg-background p-4 md:p-8">
        <div className="max-w-3xl mx-auto flex flex-col gap-6">
            <div className="text-center flex flex-col gap-2">
                <h1 className="text-3xl md:text-4xl font-bold text-foreground">🔢 Ah-Counter</h1>
                <p className="text-muted-foreground">Track filler words for each speaker</p>
            </div>

            <div className="rounded-xl border border-border bg-card p-6">
                <h2 className="text-lg font-semibold mb-4">Add Speaker</h2>
                <div className="flex gap-3">
                    <input
                        type="text"
                        value={new_name}
                        onChange={handle_name_change}
                        onKeyDown={handle_key_down}
                        placeholder="Speaker name..."
                        className="flex-1 p-3 rounded-lg border border-input bg-background text-foreground text-base"
                    />
                    <button
                        onClick={handle_add}
                        className="px-6 py-3 rounded-lg bg-primary text-primary-foreground font-semibold hover:opacity-90 transition-opacity"
                    >
                        + Add
                    </button>
                </div>
            </div>

            {not has_speakers and <div className="rounded-xl border border-border bg-card p-12 text-center">
                <p className="text-4xl mb-3">🎤</p>
                <p className="text-muted-foreground">No speakers yet. Add a speaker above to start counting.</p>
            </div>}

            {[<div key={str(i)} className="rounded-xl border border-border bg-card p-6">
                <div className="flex items-center justify-between mb-4">
                    <div className="flex items-center gap-3">
                        <div className="w-8 h-8 rounded-full bg-primary text-primary-foreground flex items-center justify-center font-bold text-sm">
                            {str(i + 1)}
                        </div>
                        <h3 className="text-lg font-semibold">{speakers[i]["name"]}</h3>
                        <span className="text-sm text-muted-foreground">{"Total: " + str(get_total(speakers[i]))}</span>
                    </div>
                    <button
                        onClick={lambda(e: MouseEvent) -> None { handle_remove(i); }}
                        className="text-muted-foreground hover:text-destructive transition-colors text-sm"
                    >
                        ✕ Remove
                    </button>
                </div>
                <div className="flex flex-wrap gap-2">
                    {[<button
                        key={FILLER_WORDS[j]}
                        onClick={lambda(e: MouseEvent) -> None { handle_increment(i, str(FILLER_WORDS[j])); }}
                        className="flex items-center gap-2 px-3 py-2 rounded-lg border border-border bg-background hover:bg-muted transition-colors text-sm font-medium"
                    >
                        <span>{FILLER_WORDS[j]}</span>
                        <span className={cn(["min-w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold",
                            "bg-primary text-primary-foreground" if int(speakers[i]["counts"][FILLER_WORDS[j]]) > 0 else "bg-muted text-muted-foreground"
                        ])}>
                            {str(int(speakers[i]["counts"][FILLER_WORDS[j]]))}
                        </span>
                    </button> for j in range(len(FILLER_WORDS))]}
                </div>
            </div> for i in range(len(speakers))]}

            {has_speakers and <div className="flex justify-center gap-4">
                <button
                    onClick={handle_toggle_report}
                    className="px-6 py-3 rounded-lg bg-primary text-primary-foreground font-semibold hover:opacity-90 transition-opacity"
                >
                    {report_btn_label}
                </button>
                <button
                    onClick={handle_reset}
                    className="px-6 py-3 rounded-lg border border-border bg-background hover:bg-muted text-foreground font-semibold transition-colors"
                >
                    🔄 Reset All
                </button>
            </div>}

            {show_report and <div className="rounded-xl border border-border bg-card p-6">
                <h2 className="text-lg font-semibold mb-4">📊 Meeting Report</h2>
                <div className="flex flex-col gap-4">
                    {[<div key={"r" + str(i)} className="flex flex-col gap-2 pb-3 border-b border-border">
                        <div className="flex items-center justify-between">
                            <span className="font-medium">{speakers[i]["name"]}</span>
                            <span className="text-sm font-bold text-primary">{"Total: " + str(get_total(speakers[i]))}</span>
                        </div>
                        <div className="flex flex-wrap gap-2">
                            {[<span key={"rw" + str(j)} className={cn(["text-xs px-2 py-1 rounded-full",
                                "bg-destructive/10 text-destructive" if int(speakers[i]["counts"][FILLER_WORDS[j]]) > 3 else "bg-muted text-muted-foreground"
                            ])}>
                                {str(FILLER_WORDS[j]) + ": " + str(int(speakers[i]["counts"][FILLER_WORDS[j]]))}
                            </span> for j in range(len(FILLER_WORDS)) if int(speakers[i]["counts"][FILLER_WORDS[j]]) > 0]}
                        </div>
                    </div> for i in range(len(speakers))]}
                </div>
            </div>}
        </div>
    </div>;
}
