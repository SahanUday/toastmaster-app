import from .ui.card { Card, CardHeader, CardTitle, CardDescription, CardContent }
import from .ui.button { Button }
import from .ui.badge { Badge }
import from .ui.input { Input }
cl import from "@hugeicons/react" { HugeiconsIcon }
cl import from "@hugeicons/core-free-icons" { Book01Icon, UserAdd01Icon, Delete01Icon, RefreshIcon, PencilEdit01Icon, CheckmarkCircle01Icon }

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
            s: any = speakers[i];
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
            s: any = speakers[i];
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

    return <div className="min-h-screen bg-background">
        <div className="relative overflow-hidden hero-gradient px-6 py-10 md:py-14">
            <div className="absolute inset-0 opacity-10">
                <div className="absolute top-4 right-10 size-32 rounded-full bg-emerald-400/30 blur-2xl"></div>
            </div>
            <div className="relative max-w-3xl mx-auto flex items-center gap-4">
                <div className="size-12 rounded-2xl bg-emerald-500 flex items-center justify-center text-white shadow-lg shadow-emerald-500/40">
                    <HugeiconsIcon icon={Book01Icon} strokeWidth={1.5} className="size-6" />
                </div>
                <div>
                    <h1 className="text-2xl font-bold text-white">Grammarian</h1>
                    <p className="text-white/60 text-sm">Word of the Day + grammar observations</p>
                </div>
            </div>
        </div>

        <div className="max-w-3xl mx-auto px-4 py-8 flex flex-col gap-6">
            {editing_word and <div className="bg-card rounded-2xl border border-border p-6 shadow-sm">
                <div className="flex items-center gap-3 mb-4">
                    <div className="size-8 rounded-lg bg-emerald-500/10 flex items-center justify-center">
                        <span className="text-emerald-600 text-sm">✨</span>
                    </div>
                    <div>
                        <h3 className="font-semibold text-foreground">Word of the Day</h3>
                        <p className="text-xs text-muted-foreground">Set an inspiring word for the meeting</p>
                    </div>
                </div>
                <div className="flex gap-3">
                    <Input
                        value={word_of_day}
                        onChange={handle_word_change}
                        placeholder="Enter today's word (e.g. 'Eloquent')..."
                        className="flex-1 text-base"
                    />
                    <button
                        onClick={handle_set_word}
                        className="flex items-center gap-2 px-4 py-2 bg-emerald-600 text-white rounded-xl font-semibold text-sm hover:bg-emerald-700 transition-colors shadow-sm"
                    >
                        <HugeiconsIcon icon={CheckmarkCircle01Icon} strokeWidth={2} className="size-4" />
                        Set Word
                    </button>
                </div>
            </div>}

            {has_word and <div className="relative overflow-hidden rounded-2xl border-2 border-emerald-500/30 bg-gradient-to-br from-emerald-50 to-emerald-100/50 p-6">
                <div className="absolute top-0 right-0 text-8xl opacity-5 font-black leading-none translate-x-4 -translate-y-2">W</div>
                <div className="flex items-start justify-between">
                    <div className="flex flex-col gap-1">
                        <span className="text-xs font-semibold text-emerald-700 uppercase tracking-widest">Word of the Day</span>
                        <span className="text-5xl font-black text-emerald-800 leading-tight">{word_of_day}</span>
                        <span className="text-sm text-emerald-700/70 mt-1">Encourage speakers to use this word throughout the meeting</span>
                    </div>
                    <button
                        onClick={handle_edit_word}
                        className="flex items-center gap-1.5 px-3 py-1.5 bg-white/60 border border-emerald-200 text-emerald-700 rounded-lg text-xs font-medium hover:bg-white transition-colors"
                    >
                        <HugeiconsIcon icon={PencilEdit01Icon} strokeWidth={2} className="size-3.5" />
                        Change
                    </button>
                </div>
            </div>}

            <div className="bg-card rounded-2xl border border-border shadow-sm overflow-hidden">
                <div className="px-5 py-4 border-b border-border bg-muted/30">
                    <h3 className="font-semibold text-foreground">Word Usage Tracker</h3>
                    <p className="text-xs text-muted-foreground mt-0.5">Track who used the word of the day</p>
                </div>
                <div className="p-5 flex flex-col gap-4">
                    <div className="flex gap-3">
                        <Input
                            value={new_speaker}
                            onChange={handle_speaker_change}
                            onKeyDown={handle_speaker_key}
                            placeholder="Speaker name..."
                            className="flex-1"
                        />
                        <button
                            onClick={add_speaker}
                            className="flex items-center gap-2 px-4 py-2 bg-primary text-primary-foreground rounded-xl font-semibold text-sm hover:bg-primary/90 transition-colors"
                        >
                            <HugeiconsIcon icon={UserAdd01Icon} strokeWidth={2} className="size-4" />
                            Add
                        </button>
                    </div>

                    {not has_speakers and <div className="text-center py-6 text-muted-foreground text-sm">
                        Add speakers to track word usage
                    </div>}

                    {[<div key={str(i)} className="flex items-center justify-between p-3 rounded-xl bg-muted/40 border border-border/60">
                        <div className="flex items-center gap-3">
                            <div className="size-9 rounded-full bg-primary text-primary-foreground flex items-center justify-center font-bold text-sm">
                                {str(speakers[i]["name"])[0].upper()}
                            </div>
                            <span className="font-medium text-sm">{str(speakers[i]["name"])}</span>
                        </div>
                        <div className="flex items-center gap-2">
                            <span className="text-xs text-muted-foreground mr-1">Used word:</span>
                            <button
                                onClick={lambda(e: MouseEvent) -> None { decrement_word_use(i); }}
                                className="size-7 rounded-lg border border-border bg-card flex items-center justify-center text-muted-foreground hover:bg-muted transition-colors text-sm font-bold"
                            >
                                −
                            </button>
                            <span className={"w-8 text-center font-black text-lg " + ("text-emerald-600" if int(speakers[i]["used_word"]) > 0 else "text-muted-foreground")}>
                                {str(int(speakers[i]["used_word"]))}
                            </span>
                            <button
                                onClick={lambda(e: MouseEvent) -> None { increment_word_use(i); }}
                                className="size-7 rounded-lg bg-emerald-600 text-white flex items-center justify-center hover:bg-emerald-700 transition-colors text-sm font-bold"
                            >
                                +
                            </button>
                            <button
                                onClick={lambda(e: MouseEvent) -> None { remove_speaker(i); }}
                                className="size-7 rounded-lg flex items-center justify-center text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors ml-1"
                            >
                                <HugeiconsIcon icon={Delete01Icon} strokeWidth={2} className="size-3.5" />
                            </button>
                        </div>
                    </div> for i in range(len(speakers))]}
                </div>
            </div>

            <div className="bg-card rounded-2xl border border-border shadow-sm overflow-hidden">
                <div className="px-5 py-4 border-b border-border bg-muted/30">
                    <h3 className="font-semibold text-foreground">Grammar Notes</h3>
                    <p className="text-xs text-muted-foreground mt-0.5">Log good usage and mistakes during the meeting</p>
                </div>
                <div className="p-5 flex flex-col gap-4">
                    <div className="flex gap-2">
                        <select
                            value={note_type}
                            onChange={handle_note_type_change}
                            className="p-2.5 rounded-xl border border-input bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring"
                        >
                            <option value="good">👍 Good</option>
                            <option value="bad">👎 Mistake</option>
                        </select>
                        <Input
                            value={new_note}
                            onChange={handle_note_change}
                            onKeyDown={handle_note_key}
                            placeholder="Note (e.g. 'Alice used a great metaphor')..."
                            className="flex-1"
                        />
                        <button
                            onClick={add_note}
                            className="px-4 py-2 bg-primary text-primary-foreground rounded-xl font-semibold text-sm hover:bg-primary/90 transition-colors"
                        >
                            Add
                        </button>
                    </div>

                    {not has_notes and <div className="text-center py-4 text-muted-foreground text-sm">
                        No notes yet. Add grammar observations above.
                    </div>}

                    {[<div key={str(i)} className={"flex items-start justify-between p-3.5 rounded-xl border " + ("bg-emerald-50 border-emerald-200/70" if str(notes[i]["type"]) == "good" else "bg-red-50 border-red-200/70")}>
                        <div className="flex items-start gap-3">
                            <span className="text-base mt-0.5">{"👍" if str(notes[i]["type"]) == "good" else "👎"}</span>
                            <span className={"text-sm leading-relaxed " + ("text-emerald-800" if str(notes[i]["type"]) == "good" else "text-red-800")}>
                                {str(notes[i]["text"])}
                            </span>
                        </div>
                        <button
                            onClick={lambda(e: MouseEvent) -> None { remove_note(i); }}
                            className="size-6 rounded-lg flex items-center justify-center text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors shrink-0 ml-2"
                        >
                            <HugeiconsIcon icon={Delete01Icon} strokeWidth={2} className="size-3.5" />
                        </button>
                    </div> for i in range(len(notes))]}
                </div>
            </div>

            <div className="flex justify-center">
                <button
                    onClick={handle_reset}
                    className="flex items-center gap-2 px-5 py-2.5 bg-card border border-destructive/30 hover:bg-destructive/5 text-destructive rounded-xl font-semibold text-sm transition-colors"
                >
                    <HugeiconsIcon icon={RefreshIcon} strokeWidth={2} className="size-4" />
                    Reset All
                </button>
            </div>
        </div>
    </div>;
}
