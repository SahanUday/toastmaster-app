import from .ui.button { Button }
import from .ui.badge { Badge }
import from .ui.input { Input }
import from .ui.tabs { Tabs, TabsList, TabsTrigger, TabsContent }
cl import from "@hugeicons/react" { HugeiconsIcon }
cl import from "@hugeicons/core-free-icons" { CalendarAdd01Icon, UserAdd01Icon, Delete01Icon, ArrowLeft01Icon, UserIcon, CalendarCheckIn01Icon }
sv import from ..services.planner { get_planner_data, add_planner_member, remove_planner_member, add_planner_meeting, remove_planner_meeting, assign_meeting_role }

glob ROLES: list = [
    "Toastmaster of the Day",
    "Timer",
    "Ah-Counter",
    "Grammarian",
    "Table Topics Master",
    "General Evaluator",
    "Speech Evaluator 1",
    "Speech Evaluator 2",
    "Sergeant at Arms"
];

def:pub MeetingPlanner() -> JsxElement {
    has members: list = [];
    has meetings: list = [];
    has loading: bool = True;
    has new_member: str = "";
    has new_date: str = "";
    has new_theme: str = "";
    has selected_meeting: int = -1;
    has show_schedule: bool = False;

    async can with entry {
        data: any = await get_planner_data();
        if data {
            members = list(data["members"]);
            meetings = list(data["meetings"]);
        }
        loading = False;
    }

    def handle_member_change(e: ChangeEvent) -> None {
        new_member = e.target.value;
    }

    def handle_date_change(e: ChangeEvent) -> None {
        new_date = e.target.value;
    }

    def handle_theme_change(e: ChangeEvent) -> None {
        new_theme = e.target.value;
    }

    async def do_add_member -> None {
        if new_member {
            name: str = new_member;
            new_member = "";
            data: any = await add_planner_member(name);
            if data {
                members = list(data["members"]);
                meetings = list(data["meetings"]);
            }
        }
    }

    def handle_member_key(e: KeyboardEvent) -> None {
        if e.key == "Enter" {
            do_add_member();
        }
    }

    async def do_remove_member(member_id: str) -> None {
        data: any = await remove_planner_member(member_id);
        if data {
            members = list(data["members"]);
            meetings = list(data["meetings"]);
        }
    }

    async def do_add_meeting -> None {
        if new_date {
            date: str = new_date;
            theme: str = new_theme;
            new_date = "";
            new_theme = "";
            data: any = await add_planner_meeting(date, theme);
            if data {
                members = list(data["members"]);
                meetings = list(data["meetings"]);
                selected_meeting = len(list(data["meetings"])) - 1;
                show_schedule = True;
            }
        }
    }

    async def do_remove_meeting(meeting_id: str) -> None {
        data: any = await remove_planner_meeting(meeting_id);
        if data {
            members = list(data["members"]);
            meetings = list(data["meetings"]);
        }
        selected_meeting = -1;
        show_schedule = False;
    }

    async def do_assign_role(meeting_id: str, role: str, member_name: str) -> None {
        data: any = await assign_meeting_role(meeting_id, role, member_name);
        if data {
            members = list(data["members"]);
            meetings = list(data["meetings"]);
        }
    }

    has_members: bool = len(members) > 0;
    has_meetings: bool = len(meetings) > 0;
    show_detail: bool = show_schedule and selected_meeting >= 0 and selected_meeting < len(meetings);

    return <div className="min-h-screen bg-background">
        <div className="relative overflow-hidden hero-gradient px-6 py-10 md:py-14">
            <div className="absolute inset-0 opacity-10">
                <div className="absolute top-4 right-10 size-32 rounded-full bg-amber-400/30 blur-2xl"></div>
            </div>
            <div className="relative max-w-4xl mx-auto flex items-center gap-4">
                <div className="size-12 rounded-2xl bg-amber-400 flex items-center justify-center text-amber-950 shadow-lg shadow-amber-400/40">
                    <HugeiconsIcon icon={CalendarAdd01Icon} strokeWidth={1.5} className="size-6" />
                </div>
                <div>
                    <h1 className="text-2xl font-bold text-white">Meeting Planner</h1>
                    <p className="text-white/60 text-sm">Schedule meetings and assign roles — shared across all devices</p>
                </div>
                <div className="ml-auto flex items-center gap-1.5 bg-emerald-500/20 border border-emerald-400/30 rounded-xl px-3 py-1.5">
                    <span className="size-2 rounded-full bg-emerald-400 animate-pulse"></span>
                    <span className="text-emerald-300 text-xs font-medium">Live Sync</span>
                </div>
            </div>
        </div>

        <div className="max-w-4xl mx-auto px-4 py-8 flex flex-col gap-6">
            {loading and <div className="flex flex-col items-center justify-center py-24 gap-4">
                <div className="size-10 rounded-full border-4 border-primary/20 border-t-primary animate-spin"></div>
                <p className="text-muted-foreground text-sm">Loading club data...</p>
            </div>}

            {not loading and not show_detail and <Tabs defaultValue="members">
                <TabsList className="w-full">
                    <TabsTrigger value="members" className="flex-1">
                        <HugeiconsIcon icon={UserIcon} strokeWidth={2} className="size-4 mr-1.5" />
                        {"Members (" + str(len(members)) + ")"}
                    </TabsTrigger>
                    <TabsTrigger value="meetings" className="flex-1">
                        <HugeiconsIcon icon={CalendarCheckIn01Icon} strokeWidth={2} className="size-4 mr-1.5" />
                        {"Meetings (" + str(len(meetings)) + ")"}
                    </TabsTrigger>
                </TabsList>

                <TabsContent value="members" className="mt-4 flex flex-col gap-4">
                    <div className="bg-card rounded-2xl border border-border p-5 shadow-sm">
                        <h3 className="font-semibold text-sm text-foreground mb-3">Add Club Member</h3>
                        <div className="flex gap-3">
                            <Input
                                value={new_member}
                                onChange={handle_member_change}
                                onKeyDown={handle_member_key}
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
                        <div className="size-16 rounded-2xl bg-primary/10 flex items-center justify-center">
                            <HugeiconsIcon icon={UserIcon} strokeWidth={1} className="size-8 text-primary" />
                        </div>
                        <p className="font-semibold text-foreground">No members yet</p>
                        <p className="text-sm text-muted-foreground">Add your club members to assign them to roles</p>
                    </div>}

                    {has_members and <div className="bg-card rounded-2xl border border-border shadow-sm overflow-hidden">
                        <div className="px-5 py-4 border-b border-border bg-muted/30">
                            <h3 className="font-semibold text-foreground">{"Club Members (" + str(len(members)) + ")"}</h3>
                        </div>
                        <div className="p-4 flex flex-col gap-2">
                            {[<div key={str(i)} className="flex items-center justify-between p-3 rounded-xl bg-muted/40 border border-border/60">
                                <div className="flex items-center gap-3">
                                    <div className="size-9 rounded-full bg-primary text-primary-foreground flex items-center justify-center font-bold text-sm">
                                        {str(members[i]["name"])[0].upper()}
                                    </div>
                                    <span className="font-medium text-sm">{str(members[i]["name"])}</span>
                                </div>
                                <button
                                    onClick={lambda(e: MouseEvent) -> None { do_remove_member(str(members[i]["id"])); }}
                                    className="size-7 rounded-lg flex items-center justify-center text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors"
                                >
                                    <HugeiconsIcon icon={Delete01Icon} strokeWidth={2} className="size-4" />
                                </button>
                            </div> for i in range(len(members))]}
                        </div>
                    </div>}
                </TabsContent>

                <TabsContent value="meetings" className="mt-4 flex flex-col gap-4">
                    <div className="bg-card rounded-2xl border border-border p-5 shadow-sm">
                        <h3 className="font-semibold text-sm text-foreground mb-3">Schedule a Meeting</h3>
                        <div className="flex flex-col gap-3">
                            <Input
                                type="date"
                                value={new_date}
                                onChange={handle_date_change}
                            />
                            <Input
                                value={new_theme}
                                onChange={handle_theme_change}
                                placeholder="Meeting theme (optional, e.g. 'Leadership')..."
                            />
                            <button
                                onClick={do_add_meeting}
                                className="flex items-center justify-center gap-2 px-4 py-2.5 bg-amber-500 text-white rounded-xl font-semibold text-sm hover:bg-amber-600 transition-colors shadow-sm"
                            >
                                <HugeiconsIcon icon={CalendarAdd01Icon} strokeWidth={2} className="size-4" />
                                Create Meeting
                            </button>
                        </div>
                    </div>

                    {not has_meetings and <div className="bg-card rounded-2xl border border-dashed border-border p-16 text-center flex flex-col items-center gap-3">
                        <div className="size-16 rounded-2xl bg-amber-500/10 flex items-center justify-center">
                            <HugeiconsIcon icon={CalendarAdd01Icon} strokeWidth={1} className="size-8 text-amber-600" />
                        </div>
                        <p className="font-semibold text-foreground">No meetings scheduled</p>
                        <p className="text-sm text-muted-foreground">Create your first meeting above</p>
                    </div>}

                    {has_meetings and <div className="bg-card rounded-2xl border border-border shadow-sm overflow-hidden">
                        <div className="px-5 py-4 border-b border-border bg-muted/30">
                            <h3 className="font-semibold text-foreground">Scheduled Meetings</h3>
                        </div>
                        <div className="p-4 flex flex-col gap-3">
                            {[<button key={str(i)}
                                className="w-full flex items-center justify-between p-4 rounded-xl border border-border bg-muted/20 cursor-pointer hover:bg-muted hover:border-primary/30 transition-all text-left card-hover"
                                onClick={lambda(e: MouseEvent) -> None { selected_meeting = i; show_schedule = True; }}>
                                <div className="flex items-center gap-4">
                                    <div className="size-12 rounded-xl bg-amber-500/10 flex flex-col items-center justify-center border border-amber-200/50">
                                        <span className="text-xs font-bold text-amber-700 leading-none">{str(meetings[i]["date"])[5:7]}</span>
                                        <span className="text-lg font-black text-amber-700 leading-none">{str(meetings[i]["date"])[8:10]}</span>
                                    </div>
                                    <div className="flex flex-col gap-0.5">
                                        <span className="font-semibold text-sm text-foreground">{str(meetings[i]["date"])}</span>
                                        <span className="text-xs text-muted-foreground">{"Theme: " + str(meetings[i]["theme"]) if meetings[i]["theme"] else "No theme set"}</span>
                                    </div>
                                </div>
                                <div className="flex items-center gap-2">
                                    <span className="text-xs font-medium text-primary bg-primary/10 border border-primary/20 px-2.5 py-1 rounded-lg">Assign roles →</span>
                                    <button
                                        onClick={lambda(e: MouseEvent) -> None { e.stopPropagation(); do_remove_meeting(str(meetings[i]["id"])); }}
                                        className="size-7 rounded-lg flex items-center justify-center text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors"
                                    >
                                        <HugeiconsIcon icon={Delete01Icon} strokeWidth={2} className="size-4" />
                                    </button>
                                </div>
                            </button> for i in range(len(meetings))]}
                        </div>
                    </div>}
                </TabsContent>
            </Tabs>}

            {not loading and show_detail and <div className="flex flex-col gap-5">
                <div className="flex items-center gap-3">
                    <button
                        onClick={lambda(e: MouseEvent) -> None { show_schedule = False; }}
                        className="flex items-center gap-1.5 px-3 py-1.5 bg-card border border-border hover:bg-muted text-foreground rounded-lg text-sm font-medium transition-colors"
                    >
                        <HugeiconsIcon icon={ArrowLeft01Icon} strokeWidth={2} className="size-4" />
                        Back
                    </button>
                    <div className="flex-1 flex items-center gap-3">
                        <div className="size-1.5 rounded-full bg-border"></div>
                        <span className="font-semibold text-foreground">{str(meetings[selected_meeting]["date"])}</span>
                        {meetings[selected_meeting]["theme"] and <span className="text-sm text-muted-foreground">{"— " + str(meetings[selected_meeting]["theme"])}</span>}
                    </div>
                </div>

                {not has_members and <div className="bg-amber-50 border border-amber-200 rounded-2xl p-6 text-center flex flex-col items-center gap-3">
                    <p className="text-amber-800 font-medium">Add members first to assign roles.</p>
                    <button
                        onClick={lambda(e: MouseEvent) -> None { show_schedule = False; }}
                        className="px-4 py-2 bg-amber-500 text-white rounded-xl text-sm font-semibold hover:bg-amber-600 transition-colors"
                    >
                        Go to Members Tab
                    </button>
                </div>}

                {has_members and <div className="bg-card rounded-2xl border border-border shadow-sm overflow-hidden">
                    <div className="px-5 py-4 border-b border-border bg-muted/30">
                        <h3 className="font-semibold text-foreground">Role Assignments</h3>
                        <p className="text-xs text-muted-foreground mt-0.5">Assign a member to each role for this meeting</p>
                    </div>
                    <div className="p-5 flex flex-col gap-3">
                        {[<div key={str(k)} className="flex items-center gap-4 p-3 rounded-xl bg-muted/30 border border-border/60">
                            <div className="w-52 shrink-0">
                                <span className="text-sm font-semibold text-foreground">{str(ROLES[k])}</span>
                            </div>
                            <select
                                value={str(meetings[selected_meeting]["roles"][ROLES[k]]) if meetings[selected_meeting]["roles"] and ROLES[k] in meetings[selected_meeting]["roles"] else ""}
                                onChange={lambda(e: ChangeEvent) -> None { do_assign_role(str(meetings[selected_meeting]["id"]), str(ROLES[k]), e.target.value); }}
                                className="flex-1 p-2.5 rounded-xl border border-input bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring"
                            >
                                <option value="">— Unassigned —</option>
                                {[<option key={str(m)} value={str(members[m]["name"])}>{str(members[m]["name"])}</option> for m in range(len(members))]}
                            </select>
                            {meetings[selected_meeting]["roles"] and ROLES[k] in meetings[selected_meeting]["roles"] and str(meetings[selected_meeting]["roles"][ROLES[k]]) and <span className="text-xs font-semibold text-primary bg-primary/10 border border-primary/20 px-2.5 py-1 rounded-lg shrink-0">
                                {str(meetings[selected_meeting]["roles"][ROLES[k]])}
                            </span>}
                        </div> for k in range(len(ROLES))]}
                    </div>
                </div>}
            </div>}
        </div>
    </div>;
}
