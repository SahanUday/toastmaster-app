import from ..lib.utils { cn }

glob PATHWAYS_SPEECHES: list = [
    "Ice Breaker",
    "Writing & Presenting a Speech",
    "Introduction to Vocal Variety & Body Language",
    "Evaluation & Feedback",
    "Understanding Your Leadership Style",
    "Level 1 Complete",
    "Research & Presenting",
    "Connect with Storytelling",
    "Effective Body Language",
    "Know Your Sense of Humor",
    "Level 2 Complete",
    "Persuasive Influence",
    "Inspire Your Audience",
    "Prepare for an Interview",
    "Level 3 Complete"
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
            <div className="text-center flex flex-col gap-2">
                <h1 className="text-3xl md:text-4xl font-bold text-foreground">🏆 Member Progress</h1>
                <p className="text-muted-foreground">Track Pathways speech completions</p>
            </div>

            <div className="rounded-xl border border-border bg-card p-6">
                <h2 className="text-lg font-semibold mb-4">Add Member</h2>
                <div className="flex gap-3">
                    <input
                        type="text"
                        value={new_member}
                        onChange={handle_name_change}
                        onKeyDown={handle_key}
                        placeholder="Member name..."
                        className="flex-1 p-3 rounded-lg border border-input bg-background text-foreground text-base"
                    />
                    <button
                        onClick={add_member}
                        className="px-6 py-3 rounded-lg bg-primary text-primary-foreground font-semibold hover:opacity-90 transition-opacity"
                    >
                        + Add
                    </button>
                </div>
            </div>

            {not has_members and <div className="rounded-xl border border-border bg-card p-12 text-center">
                <p className="text-4xl mb-3">🏆</p>
                <p className="text-muted-foreground">No members yet. Add club members to track their Pathways progress.</p>
            </div>}

            {has_members and not show_detail and <div className="rounded-xl border border-border bg-card p-6">
                <h2 className="text-lg font-semibold mb-4">{"Members (" + str(len(members)) + ")"}</h2>
                <div className="flex flex-col gap-3">
                    {[<div key={str(i)} className="flex items-center justify-between p-4 rounded-xl bg-muted cursor-pointer hover:bg-muted/80 transition-colors"
                        onClick={lambda(e: MouseEvent) -> None { selected_member = i; }}>
                        <div className="flex items-center gap-3">
                            <div className="w-10 h-10 rounded-full bg-primary text-primary-foreground flex items-center justify-center font-bold">
                                {str(members[i]["name"])[0].upper()}
                            </div>
                            <div className="flex flex-col gap-1">
                                <span className="font-semibold">{str(members[i]["name"])}</span>
                                <span className="text-xs text-muted-foreground">{str(get_completed(members[i])) + " / " + str(len(PATHWAYS_SPEECHES)) + " speeches completed"}</span>
                            </div>
                        </div>
                        <div className="flex items-center gap-3">
                            <div className="w-24 h-2 rounded-full bg-border overflow-hidden">
                                <div className="h-full bg-primary rounded-full transition-all" style={{"width": str(int(get_completed(members[i]) * 100 / len(PATHWAYS_SPEECHES))) + "%"}}></div>
                            </div>
                            <span className="text-sm text-muted-foreground">→</span>
                        </div>
                    </div> for i in range(len(members))]}
                </div>
            </div>}

            {show_detail and <div className="flex flex-col gap-4">
                <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-full bg-primary text-primary-foreground flex items-center justify-center font-bold">
                            {str(members[selected_member]["name"])[0].upper()}
                        </div>
                        <div>
                            <h2 className="text-lg font-semibold">{str(members[selected_member]["name"])}</h2>
                            <p className="text-sm text-muted-foreground">{str(get_completed(members[selected_member])) + " / " + str(len(PATHWAYS_SPEECHES)) + " completed"}</p>
                        </div>
                    </div>
                    <div className="flex gap-2">
                        <button
                            onClick={lambda(e: MouseEvent) -> None { remove_member(selected_member); }}
                            className="px-3 py-1.5 text-sm rounded-lg text-destructive border border-destructive/30 hover:bg-destructive/10 transition-colors"
                        >
                            Remove
                        </button>
                        <button
                            onClick={lambda(e: MouseEvent) -> None { selected_member = -1; }}
                            className="px-3 py-1.5 text-sm rounded-lg border border-border hover:bg-muted transition-colors"
                        >
                            ← Back
                        </button>
                    </div>
                </div>

                <div className="rounded-xl border border-border bg-card p-6">
                    <h3 className="font-semibold mb-4">Pathways Progress</h3>
                    <div className="flex flex-col gap-2">
                        {[<button
                            key={str(j)}
                            onClick={lambda(e: MouseEvent) -> None { toggle_speech(selected_member, str(PATHWAYS_SPEECHES[j])); }}
                            className={cn(["flex items-center gap-3 p-3 rounded-lg border text-left w-full transition-colors",
                                "bg-primary/10 border-primary/30 text-foreground" if bool(members[selected_member]["speeches"][PATHWAYS_SPEECHES[j]]) else "bg-background border-border hover:bg-muted text-muted-foreground"
                            ])}
                        >
                            <span className="text-lg">{"✅" if bool(members[selected_member]["speeches"][PATHWAYS_SPEECHES[j]]) else "⬜"}</span>
                            <span className={cn(["text-sm font-medium",
                                "text-foreground" if bool(members[selected_member]["speeches"][PATHWAYS_SPEECHES[j]]) else "text-muted-foreground"
                            ])}>{str(PATHWAYS_SPEECHES[j])}</span>
                        </button> for j in range(len(PATHWAYS_SPEECHES))]}
                    </div>
                </div>
            </div>}
        </div>
    </div>;
}
