import from ..lib.utils { cn }

glob gram_ref: dict = {"word": "", "speakers": [], "notes": []};

def:pub Grammarian() -> JsxElement {
    has word_of_day: str = "";
    has editing_word: bool = True;
    has speakers: list = [];
    has notes: list = [];
    has new_speaker: str = "";
    has new_note: str = "";
    has note_type: str = "good";

    def handle_word_change(e: ChangeEvent) -> None {
        word_of_day = e.target.value;
    }

    def handle_set_word(e: MouseEvent) -> None {
        if word_of_day {
            gram_ref["word"] = word_of_day;
            editing_word = False;
        }
    }

    def handle_edit_word(e: MouseEvent) -> None {
        editing_word = True;
    }

    def handle_speaker_change(e: ChangeEvent) -> None {
        new_speaker = e.target.value;
    }

    def handle_note_change(e: ChangeEvent) -> None {
        new_note = e.target.value;
    }

    def handle_note_type_change(e: ChangeEvent) -> None {
        note_type = e.target.value;
    }

    def add_speaker(e: MouseEvent) -> None {
        if new_speaker {
            sp: dict = {"name": new_speaker, "used_word": 0};
            updated: list = speakers + [sp];
            gram_ref["speakers"] = updated;
            speakers = updated;
            new_speaker = "";
        }
    }

    def handle_speaker_key(e: KeyboardEvent) -> None {
        if e.key == "Enter" and new_speaker {
            sp: dict = {"name": new_speaker, "used_word": 0};
            updated: list = speakers + [sp];
            gram_ref["speakers"] = updated;
            speakers = updated;
            new_speaker = "";
        }
    }

    def increment_word_use(idx: int) -> None {
        updated: list = [];
        for i in range(len(speakers)) {
            s: Any = speakers[i];
            if i == idx {
                updated = updated + [{"name": s["name"], "used_word": int(s["used_word"]) + 1}];
            } else {
                updated = updated + [s];
            }
        }
        gram_ref["speakers"] = updated;
        speakers = updated;
    }

    def decrement_word_use(idx: int) -> None {
        updated: list = [];
        for i in range(len(speakers)) {
            s: Any = speakers[i];
            if i == idx {
                cur: int = int(s["used_word"]);
                updated = updated + [{"name": s["name"], "used_word": cur - 1 if cur > 0 else 0}];
            } else {
                updated = updated + [s];
            }
        }
        gram_ref["speakers"] = updated;
        speakers = updated;
    }

    def remove_speaker(idx: int) -> None {
        updated: list = [];
        for i in range(len(speakers)) {
            if i != idx {
                updated = updated + [speakers[i]];
            }
        }
        gram_ref["speakers"] = updated;
        speakers = updated;
    }

    def add_note(e: MouseEvent) -> None {
        if new_note {
            note: dict = {"text": new_note, "type": note_type};
            updated: list = notes + [note];
            gram_ref["notes"] = updated;
            notes = updated;
            new_note = "";
        }
    }

    def handle_note_key(e: KeyboardEvent) -> None {
        if e.key == "Enter" and new_note {
            note: dict = {"text": new_note, "type": note_type};
            updated: list = notes + [note];
            gram_ref["notes"] = updated;
            notes = updated;
            new_note = "";
        }
    }

    def remove_note(idx: int) -> None {
        updated: list = [];
        for i in range(len(notes)) {
            if i != idx {
                updated = updated + [notes[i]];
            }
        }
        gram_ref["notes"] = updated;
        notes = updated;
    }

    def handle_reset(e: MouseEvent) -> None {
        gram_ref["word"] = "";
        gram_ref["speakers"] = [];
        gram_ref["notes"] = [];
        word_of_day = "";
        editing_word = True;
        speakers = [];
        notes = [];
    }

    has_word: bool = word_of_day != "" and not editing_word;
    has_speakers: bool = len(speakers) > 0;
    has_notes: bool = len(notes) > 0;

    return <div className="min-h-screen bg-background p-4 md:p-8">
        <div className="max-w-3xl mx-auto flex flex-col gap-6">
            <div className="text-center flex flex-col gap-2">
                <h1 className="text-3xl md:text-4xl font-bold text-foreground">📝 Grammarian</h1>
                <p className="text-muted-foreground">Track Word of the Day usage and grammar notes</p>
            </div>

            <div className="rounded-xl border border-border bg-card p-6">
                <h2 className="text-lg font-semibold mb-4">Word of the Day</h2>
                {editing_word and <div className="flex gap-3">
                    <input
                        type="text"
                        value={word_of_day}
                        onChange={handle_word_change}
                        placeholder="Enter word of the day..."
                        className="flex-1 p-3 rounded-lg border border-input bg-background text-foreground text-base"
                    />
                    <button
                        onClick={handle_set_word}
                        className="px-6 py-3 rounded-lg bg-primary text-primary-foreground font-semibold hover:opacity-90 transition-opacity"
                    >
                        Set Word
                    </button>
                </div>}
                {has_word and <div className="flex items-center justify-between p-4 rounded-xl bg-primary/10 border border-primary/30">
                    <div className="flex flex-col gap-1">
                        <span className="text-xs text-muted-foreground uppercase tracking-wide">Today's Word</span>
                        <span className="text-2xl font-bold text-primary">{word_of_day}</span>
                    </div>
                    <button onClick={handle_edit_word} className="text-sm text-muted-foreground hover:text-foreground transition-colors">
                        ✏️ Change
                    </button>
                </div>}
            </div>

            <div className="rounded-xl border border-border bg-card p-6">
                <h2 className="text-lg font-semibold mb-4">Word Usage by Speaker</h2>
                <div className="flex gap-3 mb-4">
                    <input
                        type="text"
                        value={new_speaker}
                        onChange={handle_speaker_change}
                        onKeyDown={handle_speaker_key}
                        placeholder="Speaker name..."
                        className="flex-1 p-3 rounded-lg border border-input bg-background text-foreground text-base"
                    />
                    <button
                        onClick={add_speaker}
                        className="px-6 py-3 rounded-lg bg-primary text-primary-foreground font-semibold hover:opacity-90 transition-opacity"
                    >
                        + Add
                    </button>
                </div>

                {not has_speakers and <div className="text-center py-6 text-muted-foreground">
                    <p>Add speakers to track word usage</p>
                </div>}

                {[<div key={str(i)} className="flex items-center justify-between p-3 rounded-lg bg-muted mb-2">
                    <div className="flex items-center gap-3">
                        <div className="w-8 h-8 rounded-full bg-primary text-primary-foreground flex items-center justify-center font-bold text-sm">
                            {str(speakers[i]["name"])[0].upper()}
                        </div>
                        <span className="font-medium">{str(speakers[i]["name"])}</span>
                    </div>
                    <div className="flex items-center gap-3">
                        <span className="text-sm text-muted-foreground">Used word:</span>
                        <div className="flex items-center gap-2">
                            <button
                                onClick={lambda(e: MouseEvent) -> None { decrement_word_use(i); }}
                                className="w-7 h-7 rounded-full border border-border bg-background hover:bg-muted flex items-center justify-center text-sm font-bold"
                            >
                                −
                            </button>
                            <span className={cn(["w-8 text-center font-bold text-lg",
                                "text-primary" if int(speakers[i]["used_word"]) > 0 else "text-muted-foreground"
                            ])}>
                                {str(int(speakers[i]["used_word"]))}
                            </span>
                            <button
                                onClick={lambda(e: MouseEvent) -> None { increment_word_use(i); }}
                                className="w-7 h-7 rounded-full bg-primary text-primary-foreground hover:opacity-90 flex items-center justify-center text-sm font-bold"
                            >
                                +
                            </button>
                        </div>
                        <button
                            onClick={lambda(e: MouseEvent) -> None { remove_speaker(i); }}
                            className="text-muted-foreground hover:text-destructive transition-colors ml-2"
                        >
                            ✕
                        </button>
                    </div>
                </div> for i in range(len(speakers))]}
            </div>

            <div className="rounded-xl border border-border bg-card p-6">
                <h2 className="text-lg font-semibold mb-4">Grammar Notes</h2>
                <div className="flex gap-2 mb-3">
                    <select
                        value={note_type}
                        onChange={handle_note_type_change}
                        className="p-3 rounded-lg border border-input bg-background text-foreground text-sm"
                    >
                        <option value="good">👍 Good</option>
                        <option value="bad">👎 Mistake</option>
                    </select>
                    <input
                        type="text"
                        value={new_note}
                        onChange={handle_note_change}
                        onKeyDown={handle_note_key}
                        placeholder="Note (e.g. 'Alice used a great metaphor')..."
                        className="flex-1 p-3 rounded-lg border border-input bg-background text-foreground text-sm"
                    />
                    <button
                        onClick={add_note}
                        className="px-4 py-3 rounded-lg bg-primary text-primary-foreground font-semibold hover:opacity-90 transition-opacity text-sm"
                    >
                        + Add
                    </button>
                </div>

                {not has_notes and <div className="text-center py-4 text-muted-foreground text-sm">
                    <p>No notes yet. Add grammar observations above.</p>
                </div>}

                {[<div key={str(i)} className={cn(["flex items-start justify-between p-3 rounded-lg mb-2",
                    "bg-green-500/10 border border-green-500/20" if str(notes[i]["type"]) == "good" else "bg-destructive/10 border border-destructive/20"
                ])}>
                    <div className="flex items-start gap-2">
                        <span>{"👍" if str(notes[i]["type"]) == "good" else "👎"}</span>
                        <span className="text-sm">{str(notes[i]["text"])}</span>
                    </div>
                    <button
                        onClick={lambda(e: MouseEvent) -> None { remove_note(i); }}
                        className="text-muted-foreground hover:text-destructive transition-colors ml-2 shrink-0"
                    >
                        ✕
                    </button>
                </div> for i in range(len(notes))]}
            </div>

            <div className="flex justify-center">
                <button
                    onClick={handle_reset}
                    className="px-6 py-3 rounded-lg border border-border bg-background hover:bg-muted text-foreground font-semibold transition-colors"
                >
                    🔄 Reset All
                </button>
            </div>
        </div>
    </div>;
}
