import from ..lib.utils { cn }
import from .ui.card { Card, CardHeader, CardTitle, CardDescription, CardContent }
import from .ui.button { Button }
import from .ui.badge { Badge }
import from .ui.input { Input }
import from .ui.separator { Separator }
cl import from "@hugeicons/react" { HugeiconsIcon }
cl import from "@hugeicons/core-free-icons" { Calculator01Icon, UserAdd01Icon, Delete01Icon, RefreshIcon, ChartBarLineIcon }

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
    report_btn_label: str = "Hide Report" if show_report else "Show Report";

    return <div className="min-h-screen bg-background p-4 md:p-8">
        <div className="max-w-3xl mx-auto flex flex-col gap-6">
            <div className="flex items-center gap-3">
                <div className="size-10 rounded-xl bg-primary/10 flex items-center justify-center">
                    <HugeiconsIcon icon={Calculator01Icon} strokeWidth={1.5} className="size-5 text-primary" />
                </div>
                <div>
                    <h1 className="text-2xl font-bold text-foreground">Ah-Counter</h1>
                    <p className="text-sm text-muted-foreground">Track filler words for each speaker</p>
                </div>
            </div>

            <Card>
                <CardHeader>
                    <CardTitle>Add Speaker</CardTitle>
                    <CardDescription>Add each speaker to track their filler words</CardDescription>
                </CardHeader>
                <CardContent>
                    <div className="flex gap-3">
                        <Input
                            value={new_name}
                            onChange={handle_name_change}
                            onKeyDown={handle_key_down}
                            placeholder="Speaker name..."
                            className="flex-1"
                        />
                        <Button onClick={handle_add} className="gap-2">
                            <HugeiconsIcon icon={UserAdd01Icon} strokeWidth={2} className="size-4" />
                            Add
                        </Button>
                    </div>
                </CardContent>
            </Card>

            {not has_speakers and <Card>
                <CardContent className="py-16 text-center flex flex-col items-center gap-3">
                    <div className="size-16 rounded-2xl bg-muted flex items-center justify-center">
                        <HugeiconsIcon icon={Calculator01Icon} strokeWidth={1} className="size-8 text-muted-foreground" />
                    </div>
                    <p className="font-medium text-muted-foreground">No speakers yet</p>
                    <p className="text-sm text-muted-foreground">Add a speaker above to start counting filler words</p>
                </CardContent>
            </Card>}

            {[<Card key={str(i)}>
                <CardHeader>
                    <div className="flex items-center justify-between">
                        <div className="flex items-center gap-3">
                            <div className="size-9 rounded-full bg-primary text-primary-foreground flex items-center justify-center font-bold text-sm">
                                {str(speakers[i]["name"])[0].upper()}
                            </div>
                            <div>
                                <CardTitle className="text-base">{str(speakers[i]["name"])}</CardTitle>
                                <p className="text-xs text-muted-foreground">{"Total: " + str(get_total(speakers[i])) + " filler words"}</p>
                            </div>
                        </div>
                        <div className="flex items-center gap-2">
                            <Badge variant="secondary" className="text-sm font-bold">{str(get_total(speakers[i]))}</Badge>
                            <Button
                                variant="ghost"
                                size="icon-sm"
                                onClick={lambda(e: MouseEvent) -> None { handle_remove(i); }}
                                className="text-muted-foreground hover:text-destructive"
                            >
                                <HugeiconsIcon icon={Delete01Icon} strokeWidth={2} className="size-4" />
                            </Button>
                        </div>
                    </div>
                </CardHeader>
                <CardContent>
                    <div className="flex flex-wrap gap-2">
                        {[<button
                            key={str(FILLER_WORDS[j])}
                            onClick={lambda(e: MouseEvent) -> None { handle_increment(i, str(FILLER_WORDS[j])); }}
                            className={cn(["flex items-center gap-2 px-3 py-2 rounded-lg border text-sm font-medium transition-all",
                                "border-primary bg-primary/10 text-primary hover:bg-primary/20" if int(speakers[i]["counts"][FILLER_WORDS[j]]) > 0 else "border-border bg-background text-muted-foreground hover:bg-muted hover:text-foreground"
                            ])}
                        >
                            <span>{str(FILLER_WORDS[j])}</span>
                            <span className={cn(["size-5 rounded-full flex items-center justify-center text-xs font-bold",
                                "bg-primary text-primary-foreground" if int(speakers[i]["counts"][FILLER_WORDS[j]]) > 0 else "bg-muted text-muted-foreground"
                            ])}>
                                {str(int(speakers[i]["counts"][FILLER_WORDS[j]]))}
                            </span>
                        </button> for j in range(len(FILLER_WORDS))]}
                    </div>
                </CardContent>
            </Card> for i in range(len(speakers))]}

            {has_speakers and <div className="flex justify-center gap-3">
                <Button onClick={handle_toggle_report} variant="outline" className="gap-2">
                    <HugeiconsIcon icon={ChartBarLineIcon} strokeWidth={2} className="size-4" />
                    {report_btn_label}
                </Button>
                <Button onClick={handle_reset} variant="outline" className="gap-2 text-destructive hover:text-destructive">
                    <HugeiconsIcon icon={RefreshIcon} strokeWidth={2} className="size-4" />
                    Reset All
                </Button>
            </div>}

            {show_report and <Card>
                <CardHeader>
                    <CardTitle>Meeting Report</CardTitle>
                    <CardDescription>Summary of filler word usage</CardDescription>
                </CardHeader>
                <CardContent className="flex flex-col gap-4">
                    {[<div key={"r" + str(i)} className="flex flex-col gap-2">
                        <div className="flex items-center justify-between">
                            <span className="font-medium">{str(speakers[i]["name"])}</span>
                            <Badge variant="secondary">{"Total: " + str(get_total(speakers[i]))}</Badge>
                        </div>
                        <div className="flex flex-wrap gap-2">
                            {[<Badge
                                key={"rw" + str(j)}
                                variant="outline"
                                className={cn(["",
                                    "border-destructive/50 bg-destructive/10 text-destructive" if int(speakers[i]["counts"][FILLER_WORDS[j]]) > 3 else ""
                                ])}
                            >
                                {str(FILLER_WORDS[j]) + ": " + str(int(speakers[i]["counts"][FILLER_WORDS[j]]))}
                            </Badge> for j in range(len(FILLER_WORDS)) if int(speakers[i]["counts"][FILLER_WORDS[j]]) > 0]}
                        </div>
                        {i < len(speakers) - 1 and <Separator />}
                    </div> for i in range(len(speakers))]}
                </CardContent>
            </Card>}
        </div>
    </div>;
}
