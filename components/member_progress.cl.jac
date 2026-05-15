import from ..lib.utils { cn }
import from .ui.card { Card, CardHeader, CardTitle, CardDescription, CardContent }
import from .ui.button { Button }
import from .ui.badge { Badge }
import from .ui.input { Input }
import from .ui.progress { Progress }
import from .ui.separator { Separator }
cl import from "@hugeicons/react" { HugeiconsIcon }
cl import from "@hugeicons/core-free-icons" { Trophy01Icon, UserAdd01Icon, Delete01Icon, ArrowLeft01Icon, CheckmarkCircle01Icon, Circle01Icon }

glob PATHWAYS_SPEECHES: list = [
    "Ice Breaker",
    "Writing & Presenting a Speech",
    "Introduction to Vocal Variety & Body Language",
    "Evaluation & Feedback",
    "Understanding Your Leadership Style",
    "Level 1 Complete ✓",
    "Research & Presenting",
    "Connect with Storytelling",
    "Effective Body Language",
    "Know Your Sense of Humor",
    "Level 2 Complete ✓",
    "Persuasive Influence",
    "Inspire Your Audience",
    "Prepare for an Interview",
    "Level 3 Complete ✓"
];

glob progress_ref: dict = {"members": []};

def:pub MemberProgress() -> JsxElement {
    has members: list = [];
    has new_member: str = "";
    has selected_member: int = -1;

    def handle_name_change(e: ChangeEvent) -> None {
        new_member = e.target.value;
    }

    def add_member(e: MouseEvent) -> None {
        if new_member {
            speeches: dict = {};
            for i in range(len(PATHWAYS_SPEECHES)) {
                speeches[PATHWAYS_SPEECHES[i]] = False;
            }
            m: dict = {"name": new_member, "speeches": speeches};
            updated: list = members + [m];
            progress_ref["members"] = updated;
            members = updated;
            new_member = "";
        }
    }

    def handle_key(e: KeyboardEvent) -> None {
        if e.key == "Enter" and new_member {
            speeches: dict = {};
            for i in range(len(PATHWAYS_SPEECHES)) {
                speeches[PATHWAYS_SPEECHES[i]] = False;
            }
            m: dict = {"name": new_member, "speeches": speeches};
            updated: list = members + [m];
            progress_ref["members"] = updated;
            members = updated;
            new_member = "";
        }
    }

    def toggle_speech(member_idx: int, speech: str) -> None {
        updated: list = [];
        for i in range(len(members)) {
            mb: Any = members[i];
            if i == member_idx {
                new_speeches: dict = {};
                for j in range(len(PATHWAYS_SPEECHES)) {
                    sp: Any = PATHWAYS_SPEECHES[j];
                    new_speeches[sp] = mb["speeches"][sp];
                }
                new_speeches[speech] = not bool(mb["speeches"][speech]);
                updated = updated + [{"name": mb["name"], "speeches": new_speeches}];
            } else {
                updated = updated + [mb];
            }
        }
        progress_ref["members"] = updated;
        members = updated;
    }

    def remove_member(idx: int) -> None {
        updated: list = [];
        for i in range(len(members)) {
            if i != idx {
                updated = updated + [members[i]];
            }
        }
        progress_ref["members"] = updated;
        members = updated;
        if selected_member == idx {
            selected_member = -1;
        }
    }

    def get_completed(mb: Any) -> int {
        count: int = 0;
        for i in range(len(PATHWAYS_SPEECHES)) {
            if bool(mb["speeches"][PATHWAYS_SPEECHES[i]]) {
                count = count + 1;
            }
        }
        return count;
    }

    has_members: bool = len(members) > 0;
    show_detail: bool = selected_member >= 0 and selected_member < len(members);

    return <div className="min-h-screen bg-background p-4 md:p-8">
        <div className="max-w-3xl mx-auto flex flex-col gap-6">
            <div className="flex items-center gap-3">
                <div className="size-10 rounded-xl bg-primary/10 flex items-center justify-center">
                    <HugeiconsIcon icon={Trophy01Icon} strokeWidth={1.5} className="size-5 text-primary" />
                </div>
                <div>
                    <h1 className="text-2xl font-bold text-foreground">Member Progress</h1>
                    <p className="text-sm text-muted-foreground">Track Pathways speech completions</p>
                </div>
            </div>

            {not show_detail and <div className="flex flex-col gap-4">
                <Card>
                    <CardHeader>
                        <CardTitle>Add Member</CardTitle>
                        <CardDescription>Track a member's Pathways journey</CardDescription>
                    </CardHeader>
                    <CardContent>
                        <div className="flex gap-3">
                            <Input
                                value={new_member}
                                onChange={handle_name_change}
                                onKeyDown={handle_key}
                                placeholder="Member name..."
                                className="flex-1"
                            />
                            <Button onClick={add_member} className="gap-2">
                                <HugeiconsIcon icon={UserAdd01Icon} strokeWidth={2} className="size-4" />
                                Add
                            </Button>
                        </div>
                    </CardContent>
                </Card>

                {not has_members and <Card>
                    <CardContent className="py-16 text-center flex flex-col items-center gap-3">
                        <div className="size-16 rounded-2xl bg-muted flex items-center justify-center">
                            <HugeiconsIcon icon={Trophy01Icon} strokeWidth={1} className="size-8 text-muted-foreground" />
                        </div>
                        <p className="font-medium text-muted-foreground">No members yet</p>
                        <p className="text-sm text-muted-foreground">Add club members to track their Pathways progress</p>
                    </CardContent>
                </Card>}

                {has_members and <Card>
                    <CardHeader>
                        <CardTitle>{"Members (" + str(len(members)) + ")"}</CardTitle>
                        <CardDescription>Click a member to view and update their progress</CardDescription>
                    </CardHeader>
                    <CardContent className="flex flex-col gap-3">
                        {[<div key={str(i)} className="flex items-center gap-4 p-4 rounded-xl border border-border bg-muted/30 cursor-pointer hover:bg-muted transition-colors"
                            onClick={lambda(e: MouseEvent) -> None { selected_member = i; }}>
                            <div className="size-10 rounded-full bg-primary text-primary-foreground flex items-center justify-center font-bold">
                                {str(members[i]["name"])[0].upper()}
                            </div>
                            <div className="flex flex-col gap-2 flex-1">
                                <div className="flex items-center justify-between">
                                    <span className="font-semibold">{str(members[i]["name"])}</span>
                                    <Badge variant="secondary">{str(get_completed(members[i])) + " / " + str(len(PATHWAYS_SPEECHES))}</Badge>
                                </div>
                                <Progress value={int(get_completed(members[i]) * 100 / len(PATHWAYS_SPEECHES))} className="h-2" />
                            </div>
                        </div> for i in range(len(members))]}
                    </CardContent>
                </Card>}
            </div>}

            {show_detail and <div className="flex flex-col gap-4">
                <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                        <Button
                            variant="ghost"
                            size="sm"
                            onClick={lambda(e: MouseEvent) -> None { selected_member = -1; }}
                            className="gap-1.5"
                        >
                            <HugeiconsIcon icon={ArrowLeft01Icon} strokeWidth={2} className="size-4" />
                            Back
                        </Button>
                        <Separator orientation="vertical" className="h-5" />
                        <div className="flex items-center gap-3">
                            <div className="size-9 rounded-full bg-primary text-primary-foreground flex items-center justify-center font-bold text-sm">
                                {str(members[selected_member]["name"])[0].upper()}
                            </div>
                            <div>
                                <p className="font-semibold">{str(members[selected_member]["name"])}</p>
                                <p className="text-xs text-muted-foreground">{str(get_completed(members[selected_member])) + " / " + str(len(PATHWAYS_SPEECHES)) + " speeches completed"}</p>
                            </div>
                        </div>
                    </div>
                    <Button
                        variant="outline"
                        size="sm"
                        onClick={lambda(e: MouseEvent) -> None { remove_member(selected_member); }}
                        className="gap-1.5 text-destructive hover:text-destructive"
                    >
                        <HugeiconsIcon icon={Delete01Icon} strokeWidth={2} className="size-3.5" />
                        Remove
                    </Button>
                </div>

                <Card>
                    <CardHeader>
                        <CardTitle>Pathways Progress</CardTitle>
                        <CardDescription>Click a speech to mark it as complete</CardDescription>
                    </CardHeader>
                    <CardContent>
                        <Progress value={int(get_completed(members[selected_member]) * 100 / len(PATHWAYS_SPEECHES))} className="h-3 mb-6" />
                        <div className="flex flex-col gap-2">
                            {[<button
                                key={str(j)}
                                onClick={lambda(e: MouseEvent) -> None { toggle_speech(selected_member, str(PATHWAYS_SPEECHES[j])); }}
                                className={cn(["flex items-center gap-3 p-3 rounded-xl border text-left w-full transition-all",
                                    "bg-primary/10 border-primary/30" if bool(members[selected_member]["speeches"][PATHWAYS_SPEECHES[j]]) else "bg-background border-border hover:bg-muted"
                                ])}
                            >
                                {bool(members[selected_member]["speeches"][PATHWAYS_SPEECHES[j]]) and <HugeiconsIcon icon={CheckmarkCircle01Icon} strokeWidth={2} className="size-5 text-primary shrink-0" />}
                                {not bool(members[selected_member]["speeches"][PATHWAYS_SPEECHES[j]]) and <HugeiconsIcon icon={Circle01Icon} strokeWidth={1.5} className="size-5 text-muted-foreground shrink-0" />}
                                <span className={cn(["text-sm font-medium",
                                    "text-foreground" if bool(members[selected_member]["speeches"][PATHWAYS_SPEECHES[j]]) else "text-muted-foreground"
                                ])}>{str(PATHWAYS_SPEECHES[j])}</span>
                            </button> for j in range(len(PATHWAYS_SPEECHES))]}
                        </div>
                    </CardContent>
                </Card>
            </div>}
        </div>
    </div>;
}
