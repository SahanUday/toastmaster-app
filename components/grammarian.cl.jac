import from ..lib.utils { cn }
import from .ui.card { Card, CardHeader, CardTitle, CardDescription, CardContent }
import from .ui.button { Button }
import from .ui.badge { Badge }
import from .ui.input { Input }
import from .ui.separator { Separator }
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
            <div className="flex items-center gap-3">
                <div className="size-10 rounded-xl bg-primary/10 flex items-center justify-center">
                    <HugeiconsIcon icon={Book01Icon} strokeWidth={1.5} className="size-5 text-primary" />
                </div>
                <div>
                    <h1 className="text-2xl font-bold text-foreground">Grammarian</h1>
                    <p className="text-sm text-muted-foreground">Word of the Day + grammar notes</p>
                </div>
            </div>

            <Card>
                <CardHeader>
                    <CardTitle>Word of the Day</CardTitle>
                    <CardDescription>Introduce a word at the start of the meeting</CardDescription>
                </CardHeader>
                <CardContent>
                    {editing_word and <div className="flex gap-3">
                        <Input
                            value={word_of_day}
                            onChange={handle_word_change}
                            placeholder="Enter word of the day..."
                            className="flex-1"
                        />
                        <Button onClick={handle_set_word} className="gap-2">
                            <HugeiconsIcon icon={CheckmarkCircle01Icon} strokeWidth={2} className="size-4" />
                            Set Word
                        </Button>
                    </div>}
                    {has_word and <div className="flex items-center justify-between p-4 rounded-xl bg-primary/10 border border-primary/20">
                        <div className="flex flex-col gap-1">
                            <span className="text-xs text-muted-foreground uppercase tracking-wide font-medium">Today's Word</span>
                            <span className="text-3xl font-bold text-primary">{word_of_day}</span>
                        </div>
                        <Button variant="ghost" size="sm" onClick={handle_edit_word} className="gap-1.5 text-muted-foreground">
                            <HugeiconsIcon icon={PencilEdit01Icon} strokeWidth={2} className="size-3.5" />
                            Change
                        </Button>
                    </div>}
                </CardContent>
            </Card>

            <Card>
                <CardHeader>
                    <CardTitle>Word Usage by Speaker</CardTitle>
                    <CardDescription>Track who used the word of the day</CardDescription>
                </CardHeader>
                <CardContent className="flex flex-col gap-4">
                    <div className="flex gap-3">
                        <Input
                            value={new_speaker}
                            onChange={handle_speaker_change}
                            onKeyDown={handle_speaker_key}
                            placeholder="Speaker name..."
                            className="flex-1"
                        />
                        <Button onClick={add_speaker} className="gap-2">
                            <HugeiconsIcon icon={UserAdd01Icon} strokeWidth={2} className="size-4" />
                            Add
                        </Button>
                    </div>

                    {not has_speakers and <div className="text-center py-6 text-muted-foreground text-sm">
                        <p>Add speakers to track word usage</p>
                    </div>}

                    {[<div key={str(i)} className="flex items-center justify-between p-3 rounded-xl bg-muted">
                        <div className="flex items-center gap-3">
                            <div className="size-9 rounded-full bg-primary text-primary-foreground flex items-center justify-center font-bold text-sm">
                                {str(speakers[i]["name"])[0].upper()}
                            </div>
                            <span className="font-medium">{str(speakers[i]["name"])}</span>
                        </div>
                        <div className="flex items-center gap-3">
                            <span className="text-sm text-muted-foreground">Used word:</span>
                            <div className="flex items-center gap-2">
                                <Button
                                    variant="outline"
                                    size="icon-sm"
                                    onClick={lambda(e: MouseEvent) -> None { decrement_word_use(i); }}
                                >
                                    −
                                </Button>
                                <span className={cn(["w-8 text-center font-bold text-lg",
                                    "text-primary" if int(speakers[i]["used_word"]) > 0 else "text-muted-foreground"
                                ])}>
                                    {str(int(speakers[i]["used_word"]))}
                                </span>
                                <Button
                                    size="icon-sm"
                                    onClick={lambda(e: MouseEvent) -> None { increment_word_use(i); }}
                                >
                                    +
                                </Button>
                            </div>
                            <Button
                                variant="ghost"
                                size="icon-sm"
                                onClick={lambda(e: MouseEvent) -> None { remove_speaker(i); }}
                                className="text-muted-foreground hover:text-destructive"
                            >
                                <HugeiconsIcon icon={Delete01Icon} strokeWidth={2} className="size-4" />
                            </Button>
                        </div>
                    </div> for i in range(len(speakers))]}
                </CardContent>
            </Card>

            <Card>
                <CardHeader>
                    <CardTitle>Grammar Notes</CardTitle>
                    <CardDescription>Note good usage and mistakes during the meeting</CardDescription>
                </CardHeader>
                <CardContent className="flex flex-col gap-4">
                    <div className="flex gap-2">
                        <select
                            value={note_type}
                            onChange={handle_note_type_change}
                            className="p-2.5 rounded-lg border border-input bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring"
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
                        <Button onClick={add_note} className="gap-2">Add</Button>
                    </div>

                    {not has_notes and <div className="text-center py-4 text-muted-foreground text-sm">
                        <p>No notes yet. Add grammar observations above.</p>
                    </div>}

                    {[<div key={str(i)} className={cn(["flex items-start justify-between p-3 rounded-xl border",
                        "bg-green-500/5 border-green-500/20" if str(notes[i]["type"]) == "good" else "bg-destructive/5 border-destructive/20"
                    ])}>
                        <div className="flex items-start gap-2">
                            <span>{"👍" if str(notes[i]["type"]) == "good" else "👎"}</span>
                            <span className="text-sm">{str(notes[i]["text"])}</span>
                        </div>
                        <Button
                            variant="ghost"
                            size="icon-sm"
                            onClick={lambda(e: MouseEvent) -> None { remove_note(i); }}
                            className="text-muted-foreground hover:text-destructive shrink-0"
                        >
                            <HugeiconsIcon icon={Delete01Icon} strokeWidth={2} className="size-3.5" />
                        </Button>
                    </div> for i in range(len(notes))]}
                </CardContent>
            </Card>

            <div className="flex justify-center">
                <Button variant="outline" onClick={handle_reset} className="gap-2 text-destructive hover:text-destructive">
                    <HugeiconsIcon icon={RefreshIcon} strokeWidth={2} className="size-4" />
                    Reset All
                </Button>
            </div>
        </div>
    </div>;
}
