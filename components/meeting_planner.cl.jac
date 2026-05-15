import from ..lib.utils { cn }
import from .ui.card { Card, CardHeader, CardTitle, CardDescription, CardContent }
import from .ui.button { Button }
import from .ui.badge { Badge }
import from .ui.input { Input }
import from .ui.separator { Separator }
import from .ui.tabs { Tabs, TabsList, TabsTrigger, TabsContent }
cl import from "@hugeicons/react" { HugeiconsIcon }
cl import from "@hugeicons/core-free-icons" { CalendarAdd01Icon, UserAdd01Icon, Delete01Icon, ArrowLeft01Icon, UserIcon, CalendarCheckIn01Icon }

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

glob planner_ref: dict = {"members": [], "meetings": []};

def:pub MeetingPlanner() -> JsxElement {
    has members: list = [];
    has meetings: list = [];
    has new_member: str = "";
    has new_date: str = "";
    has new_theme: str = "";
    has selected_meeting: int = -1;
    has show_schedule: bool = False;

    def handle_member_change(e: ChangeEvent) -> None {
        new_member = e.target.value;
    }

    def handle_date_change(e: ChangeEvent) -> None {
        new_date = e.target.value;
    }

    def handle_theme_change(e: ChangeEvent) -> None {
        new_theme = e.target.value;
    }

    def add_member(e: MouseEvent) -> None {
        if new_member {
            updated: list = members + [{"name": new_member}];
            planner_ref["members"] = updated;
            members = updated;
            new_member = "";
        }
    }

    def handle_member_key(e: KeyboardEvent) -> None {
        if e.key == "Enter" and new_member {
            updated: list = members + [{"name": new_member}];
            planner_ref["members"] = updated;
            members = updated;
            new_member = "";
        }
    }

    def remove_member(idx: int) -> None {
        updated: list = [];
        for i in range(len(members)) {
            if i != idx {
                updated = updated + [members[i]];
            }
        }
        planner_ref["members"] = updated;
        members = updated;
    }

    def add_meeting(e: MouseEvent) -> None {
        if new_date {
            roles_dict: dict = {};
            for i in range(len(ROLES)) {
                roles_dict[ROLES[i]] = "";
            }
            meeting: dict = {"date": new_date, "theme": new_theme, "roles": roles_dict};
            updated: list = meetings + [meeting];
            planner_ref["meetings"] = updated;
            meetings = updated;
            new_date = "";
            new_theme = "";
            selected_meeting = len(updated) - 1;
            show_schedule = True;
        }
    }

    def assign_role(meeting_idx: int, role: str, member_name: str) -> None {
        updated: list = [];
        for i in range(len(meetings)) {
            m: Any = meetings[i];
            if i == meeting_idx {
                new_roles: dict = {};
                for j in range(len(ROLES)) {
                    r: Any = ROLES[j];
                    new_roles[r] = m["roles"][r];
                }
                new_roles[role] = member_name;
                updated = updated + [{"date": m["date"], "theme": m["theme"], "roles": new_roles}];
            } else {
                updated = updated + [m];
            }
        }
        planner_ref["meetings"] = updated;
        meetings = updated;
    }

    def remove_meeting(idx: int) -> None {
        updated: list = [];
        for i in range(len(meetings)) {
            if i != idx {
                updated = updated + [meetings[i]];
            }
        }
        planner_ref["meetings"] = updated;
        meetings = updated;
        selected_meeting = -1;
        show_schedule = False;
    }

    has_members: bool = len(members) > 0;
    has_meetings: bool = len(meetings) > 0;
    show_detail: bool = show_schedule and selected_meeting >= 0 and selected_meeting < len(meetings);

    return <div className="min-h-screen bg-background p-4 md:p-8">
        <div className="max-w-4xl mx-auto flex flex-col gap-6">
            <div className="flex items-center gap-3">
                <div className="size-10 rounded-xl bg-primary/10 flex items-center justify-center">
                    <HugeiconsIcon icon={CalendarAdd01Icon} strokeWidth={1.5} className="size-5 text-primary" />
                </div>
                <div>
                    <h1 className="text-2xl font-bold text-foreground">Meeting Planner</h1>
                    <p className="text-sm text-muted-foreground">Schedule meetings and assign roles</p>
                </div>
            </div>

            {not show_detail and <Tabs defaultValue="members">
                <TabsList>
                    <TabsTrigger value="members">
                        <HugeiconsIcon icon={UserIcon} strokeWidth={2} className="size-4 mr-1.5" />
                        {"Members (" + str(len(members)) + ")"}
                    </TabsTrigger>
                    <TabsTrigger value="meetings">
                        <HugeiconsIcon icon={CalendarCheckIn01Icon} strokeWidth={2} className="size-4 mr-1.5" />
                        {"Meetings (" + str(len(meetings)) + ")"}
                    </TabsTrigger>
                </TabsList>

                <TabsContent value="members" className="mt-4 flex flex-col gap-4">
                    <Card>
                        <CardHeader>
                            <CardTitle>Add Member</CardTitle>
                            <CardDescription>Add your club members to assign them roles</CardDescription>
                        </CardHeader>
                        <CardContent>
                            <div className="flex gap-3">
                                <Input
                                    value={new_member}
                                    onChange={handle_member_change}
                                    onKeyDown={handle_member_key}
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
                                <HugeiconsIcon icon={UserIcon} strokeWidth={1} className="size-8 text-muted-foreground" />
                            </div>
                            <p className="font-medium text-muted-foreground">No members yet</p>
                            <p className="text-sm text-muted-foreground">Add your club members above</p>
                        </CardContent>
                    </Card>}

                    {has_members and <Card>
                        <CardHeader>
                            <CardTitle>{"Club Members (" + str(len(members)) + ")"}</CardTitle>
                        </CardHeader>
                        <CardContent className="flex flex-col gap-2">
                            {[<div key={str(i)} className="flex items-center justify-between p-3 rounded-xl bg-muted">
                                <div className="flex items-center gap-3">
                                    <div className="size-9 rounded-full bg-primary text-primary-foreground flex items-center justify-center font-bold text-sm">
                                        {str(members[i]["name"])[0].upper()}
                                    </div>
                                    <span className="font-medium">{str(members[i]["name"])}</span>
                                </div>
                                <Button
                                    variant="ghost"
                                    size="icon-sm"
                                    onClick={lambda(e: MouseEvent) -> None { remove_member(i); }}
                                    className="text-muted-foreground hover:text-destructive"
                                >
                                    <HugeiconsIcon icon={Delete01Icon} strokeWidth={2} className="size-4" />
                                </Button>
                            </div> for i in range(len(members))]}
                        </CardContent>
                    </Card>}
                </TabsContent>

                <TabsContent value="meetings" className="mt-4 flex flex-col gap-4">
                    <Card>
                        <CardHeader>
                            <CardTitle>Create Meeting</CardTitle>
                            <CardDescription>Schedule a new meeting and assign roles</CardDescription>
                        </CardHeader>
                        <CardContent className="flex flex-col gap-3">
                            <Input
                                type="date"
                                value={new_date}
                                onChange={handle_date_change}
                            />
                            <Input
                                value={new_theme}
                                onChange={handle_theme_change}
                                placeholder="Meeting theme (optional)..."
                            />
                            <Button onClick={add_meeting} className="gap-2">
                                <HugeiconsIcon icon={CalendarAdd01Icon} strokeWidth={2} className="size-4" />
                                Create Meeting
                            </Button>
                        </CardContent>
                    </Card>

                    {not has_meetings and <Card>
                        <CardContent className="py-16 text-center flex flex-col items-center gap-3">
                            <div className="size-16 rounded-2xl bg-muted flex items-center justify-center">
                                <HugeiconsIcon icon={CalendarAdd01Icon} strokeWidth={1} className="size-8 text-muted-foreground" />
                            </div>
                            <p className="font-medium text-muted-foreground">No meetings yet</p>
                            <p className="text-sm text-muted-foreground">Create your first meeting above</p>
                        </CardContent>
                    </Card>}

                    {has_meetings and <Card>
                        <CardHeader>
                            <CardTitle>Upcoming Meetings</CardTitle>
                        </CardHeader>
                        <CardContent className="flex flex-col gap-2">
                            {[<div key={str(i)} className="flex items-center justify-between p-4 rounded-xl border border-border bg-muted/30 cursor-pointer hover:bg-muted transition-colors"
                                onClick={lambda(e: MouseEvent) -> None { selected_meeting = i; show_schedule = True; }}>
                                <div className="flex items-center gap-3">
                                    <div className="size-10 rounded-xl bg-primary/10 flex items-center justify-center">
                                        <HugeiconsIcon icon={CalendarCheckIn01Icon} strokeWidth={1.5} className="size-5 text-primary" />
                                    </div>
                                    <div className="flex flex-col gap-0.5">
                                        <span className="font-semibold">{str(meetings[i]["date"])}</span>
                                        <span className="text-xs text-muted-foreground">{"Theme: " + str(meetings[i]["theme"]) if meetings[i]["theme"] else "No theme set"}</span>
                                    </div>
                                </div>
                                <div className="flex items-center gap-2">
                                    <Badge variant="outline" className="text-xs">Assign roles →</Badge>
                                    <Button
                                        variant="ghost"
                                        size="icon-sm"
                                        onClick={lambda(e: MouseEvent) -> None { e.stopPropagation(); remove_meeting(i); }}
                                        className="text-muted-foreground hover:text-destructive"
                                    >
                                        <HugeiconsIcon icon={Delete01Icon} strokeWidth={2} className="size-4" />
                                    </Button>
                                </div>
                            </div> for i in range(len(meetings))]}
                        </CardContent>
                    </Card>}
                </TabsContent>
            </Tabs>}

            {show_detail and <div className="flex flex-col gap-4">
                <div className="flex items-center gap-3">
                    <Button
                        variant="ghost"
                        size="sm"
                        onClick={lambda(e: MouseEvent) -> None { show_schedule = False; }}
                        className="gap-1.5"
                    >
                        <HugeiconsIcon icon={ArrowLeft01Icon} strokeWidth={2} className="size-4" />
                        Back
                    </Button>
                    <Separator orientation="vertical" className="h-5" />
                    <div>
                        <span className="font-semibold">{str(meetings[selected_meeting]["date"])}</span>
                        {meetings[selected_meeting]["theme"] and <span className="text-sm text-muted-foreground ml-2">{"— " + str(meetings[selected_meeting]["theme"])}</span>}
                    </div>
                </div>

                {not has_members and <Card>
                    <CardContent className="py-8 text-center flex flex-col items-center gap-3">
                        <p className="text-muted-foreground">Add members first to assign roles.</p>
                        <Button
                            size="sm"
                            onClick={lambda(e: MouseEvent) -> None { show_schedule = False; }}
                        >
                            Go to Members
                        </Button>
                    </CardContent>
                </Card>}

                {has_members and <Card>
                    <CardHeader>
                        <CardTitle>Role Assignments</CardTitle>
                        <CardDescription>Assign a member to each role for this meeting</CardDescription>
                    </CardHeader>
                    <CardContent className="flex flex-col gap-3">
                        {[<div key={str(k)} className="flex items-center gap-4">
                            <div className="w-52 shrink-0">
                                <span className="text-sm font-medium">{str(ROLES[k])}</span>
                            </div>
                            <select
                                value={str(meetings[selected_meeting]["roles"][ROLES[k]])}
                                onChange={lambda(e: ChangeEvent) -> None { assign_role(selected_meeting, str(ROLES[k]), e.target.value); }}
                                className="flex-1 p-2.5 rounded-lg border border-input bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring"
                            >
                                <option value="">— Unassigned —</option>
                                {[<option key={str(m)} value={str(members[m]["name"])}>{str(members[m]["name"])}</option> for m in range(len(members))]}
                            </select>
                            {str(meetings[selected_meeting]["roles"][ROLES[k]]) and <Badge variant="secondary" className="shrink-0">
                                {str(meetings[selected_meeting]["roles"][ROLES[k]])}
                            </Badge>}
                        </div> for k in range(len(ROLES))]}
                    </CardContent>
                </Card>}
            </div>}
        </div>
    </div>;
}
