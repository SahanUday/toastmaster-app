import from .ui.button { Button }
import from .ui.badge { Badge }
import from .ui.input { Input }
import from .ui.progress { Progress }
cl import from "@hugeicons/react" { HugeiconsIcon }
cl import from "@hugeicons/core-free-icons" { ChampionIcon, UserAdd01Icon, Delete01Icon, ArrowLeft01Icon, CheckmarkCircle01Icon, CircleIcon }
sv import from ..services.progress { get_progress_data, add_progress_member, remove_progress_member, toggle_progress_speech }

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

def:pub MemberProgress() -> JsxElement {
    has members: list = [];
    has loading: bool = True;
    has new_member: str = "";
    has selected_member: int = -1;

    async can with entry {
        data: any = await get_progress_data();
        if data {
            members = list(data);
        }
        loading = False;
    }

    def handle_name_change(e: ChangeEvent) -> None {
        new_member = e.target.value;
    }

    async def do_add_member -> None {
        if new_member {
            name: str = new_member;
            new_member = "";
            speeches: dict = {};
            for i in range(len(PATHWAYS_SPEECHES)) {
                speeches[PATHWAYS_SPEECHES[i]] = False;
            }
            data: any = await add_progress_member(name, speeches);
            if data {
                members = list(data);
            }
        }
    }

    def handle_key(e: KeyboardEvent) -> None {
        if e.key == "Enter" {
            do_add_member();
        }
    }

    async def do_toggle_speech(member_id: str, speech: str) -> None {
        data: any = await toggle_progress_speech(member_id, speech);
        if data {
            members = list(data);
        }
    }

    async def do_remove_member(member_id: str) -> None {
        data: any = await remove_progress_member(member_id);
        if data {
            members = list(data);
        }
        selected_member = -1;
    }

    def get_completed(mb: any) -> int {
        count: int = 0;
        for i in range(len(PATHWAYS_SPEECHES)) {
            if bool(mb["speeches"][PATHWAYS_SPEECHES[i]]) {
                count = count + 1;
            }
        }
        return count;
    }

    def avatar_color(idx: int) -> str {
        colors: list = ["bg-blue-500", "bg-purple-500", "bg-emerald-500", "bg-rose-500", "bg-amber-500", "bg-cyan-500"];
        return str(colors[idx % len(colors)]);
    }

    has_members: bool = len(members) > 0;
    show_detail: bool = selected_member >= 0 and selected_member < len(members);

    return <div className="min-h-screen bg-background">
        <div className="relative overflow-hidden hero-gradient px-6 py-10 md:py-14">
            <div className="relative max-w-3xl mx-auto flex items-center gap-4">
                <div className="size-12 rounded-2xl bg-amber-400 flex items-center justify-center text-amber-950 shadow-lg shadow-amber-400/40">
                    <HugeiconsIcon icon={ChampionIcon} strokeWidth={1.5} className="size-6" />
                </div>
                <div>
                    <h1 className="text-2xl font-bold text-white">Member Progress</h1>
                    <p className="text-white/60 text-sm">Track Pathways speech completions — shared across all devices</p>
                </div>
                <div className="ml-auto flex items-center gap-1.5 bg-emerald-500/20 border border-emerald-400/30 rounded-xl px-3 py-1.5">
                    <span className="size-2 rounded-full bg-emerald-400 animate-pulse"></span>
                    <span className="text-emerald-300 text-xs font-medium">Live Sync</span>
                </div>
            </div>
        </div>

        <div className="max-w-3xl mx-auto px-4 py-8 flex flex-col gap-6">
            {loading and <div className="flex flex-col items-center justify-center py-24 gap-4">
                <div className="size-10 rounded-full border-4 border-primary/20 border-t-primary animate-spin"></div>
                <p className="text-muted-foreground text-sm">Loading member data...</p>
            </div>}

            {not loading and not show_detail and <div className="flex flex-col gap-4">
                <div className="bg-card rounded-2xl border border-border p-5 shadow-sm">
                    <h3 className="font-semibold text-sm text-foreground mb-3">Add Member</h3>
                    <div className="flex gap-3">
                        <Input
                            value={new_member}
                            onChange={handle_name_change}
                            onKeyDown={handle_key}
                            placeholder="Member name..."
                            className="flex-1"
                        />
                        <button
                            onClick={do_add_member}
                            className="flex items-center gap-2 px-4 py-2 bg-primary text-primary-foreground rounded-xl font-semibold text-sm hover:bg-primary/90 transition-colors"
                        >
                            <HugeiconsIcon icon={UserAdd01Icon} strokeWidth={2} className="size-4" />
                            Add
                        </button>
                    </div>
                </div>

                {not has_members and <div className="bg-card rounded-2xl border border-dashed border-border p-16 text-center flex flex-col items-center gap-3">
                    <div className="size-16 rounded-2xl bg-amber-400/15 flex items-center justify-center">
                        <HugeiconsIcon icon={ChampionIcon} strokeWidth={1} className="size-8 text-amber-600" />
                    </div>
                    <p className="font-semibold text-foreground">No members yet</p>
                    <p className="text-sm text-muted-foreground">Add club members to track their Pathways progress</p>
                </div>}

                {has_members and <div className="bg-card rounded-2xl border border-border shadow-sm overflow-hidden">
                    <div className="px-5 py-4 border-b border-border bg-muted/30">
                        <h3 className="font-semibold text-foreground">{"Club Members (" + str(len(members)) + ")"}</h3>
                        <p className="text-xs text-muted-foreground mt-0.5">Click a member to view and update their progress</p>
                    </div>
                    <div className="p-4 flex flex-col gap-3">
                        {[<button key={str(i)}
                            className="w-full flex items-center gap-4 p-4 rounded-xl border border-border bg-muted/20 cursor-pointer hover:bg-muted hover:border-primary/30 transition-all text-left card-hover"
                            onClick={lambda(e: MouseEvent) -> None { selected_member = i; }}>
                            <div className={"size-11 rounded-full flex items-center justify-center font-bold text-white text-sm shadow-sm shrink-0 " + avatar_color(i)}>
                                {str(members[i]["name"])[0].upper()}
                            </div>
                            <div className="flex flex-col gap-2 flex-1 min-w-0">
                                <div className="flex items-center justify-between gap-2">
                                    <span className="font-semibold text-foreground truncate">{str(members[i]["name"])}</span>
                                    <span className="text-xs font-semibold text-primary bg-primary/10 border border-primary/20 px-2.5 py-1 rounded-lg shrink-0">
                                        {str(get_completed(members[i])) + " / " + str(len(PATHWAYS_SPEECHES))}
                                    </span>
                                </div>
                                <Progress value={int(get_completed(members[i]) * 100 / len(PATHWAYS_SPEECHES))} className="h-2" />
                            </div>
                        </button> for i in range(len(members))]}
                    </div>
                </div>}
            </div>}

            {not loading and show_detail and <div className="flex flex-col gap-5">
                <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                        <button
                            onClick={lambda(e: MouseEvent) -> None { selected_member = -1; }}
                            className="flex items-center gap-1.5 px-3 py-1.5 bg-card border border-border hover:bg-muted text-foreground rounded-lg text-sm font-medium transition-colors"
                        >
                            <HugeiconsIcon icon={ArrowLeft01Icon} strokeWidth={2} className="size-4" />
                            Back
                        </button>
                        <div className="flex items-center gap-2">
                            <div className={"size-9 rounded-full flex items-center justify-center font-bold text-white text-sm " + avatar_color(selected_member)}>
                                {str(members[selected_member]["name"])[0].upper()}
                            </div>
                            <div>
                                <p className="font-semibold text-sm text-foreground">{str(members[selected_member]["name"])}</p>
                                <p className="text-xs text-muted-foreground">{str(get_completed(members[selected_member])) + " / " + str(len(PATHWAYS_SPEECHES)) + " speeches"}</p>
                            </div>
                        </div>
                    </div>
                    <button
                        onClick={lambda(e: MouseEvent) -> None { do_remove_member(str(members[selected_member]["id"])); }}
                        className="flex items-center gap-1.5 px-3 py-1.5 bg-card border border-destructive/30 hover:bg-destructive/5 text-destructive rounded-lg text-xs font-medium transition-colors"
                    >
                        <HugeiconsIcon icon={Delete01Icon} strokeWidth={2} className="size-3.5" />
                        Remove
                    </button>
                </div>

                <div className="bg-card rounded-2xl border border-border shadow-sm overflow-hidden">
                    <div className="px-5 py-4 border-b border-border bg-muted/30">
                        <div className="flex items-center justify-between mb-2">
                            <h3 className="font-semibold text-foreground">Pathways Progress</h3>
                            <span className="text-xs font-bold text-primary">{str(int(get_completed(members[selected_member]) * 100 / len(PATHWAYS_SPEECHES))) + "%"}</span>
                        </div>
                        <Progress value={int(get_completed(members[selected_member]) * 100 / len(PATHWAYS_SPEECHES))} className="h-3" />
                        <p className="text-xs text-muted-foreground mt-2">Click a speech to mark it as complete</p>
                    </div>
                    <div className="p-4 flex flex-col gap-2">
                        {[<button
                            key={str(j)}
                            onClick={lambda(e: MouseEvent) -> None { do_toggle_speech(str(members[selected_member]["id"]), str(PATHWAYS_SPEECHES[j])); }}
                            className={"flex items-center gap-3 p-3 rounded-xl border text-left w-full transition-all " + ("bg-primary/10 border-primary/30 shadow-sm" if bool(members[selected_member]["speeches"][PATHWAYS_SPEECHES[j]]) else "bg-background border-border hover:bg-muted")}
                        >
                            {bool(members[selected_member]["speeches"][PATHWAYS_SPEECHES[j]]) and <HugeiconsIcon icon={CheckmarkCircle01Icon} strokeWidth={2} className="size-5 text-primary shrink-0" />}
                            {not bool(members[selected_member]["speeches"][PATHWAYS_SPEECHES[j]]) and <HugeiconsIcon icon={CircleIcon} strokeWidth={1.5} className="size-5 text-muted-foreground shrink-0" />}
                            <span className={"text-sm font-medium " + ("text-foreground" if bool(members[selected_member]["speeches"][PATHWAYS_SPEECHES[j]]) else "text-muted-foreground")}>{str(PATHWAYS_SPEECHES[j])}</span>
                        </button> for j in range(len(PATHWAYS_SPEECHES))]}
                    </div>
                </div>
            </div>}
        </div>
    </div>;
}
