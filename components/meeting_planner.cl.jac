import from ..lib.utils { cn }

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
    has active_tab: str = "members";
    has new_member: str = "";
    has new_date: str = "";
    has new_theme: str = "";
    has selected_meeting: int = -1;

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
            active_tab = "meetings";
        }
    }

    def select_meeting(idx: int) -> None {
        selected_meeting = idx;
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
    }

    has_members: bool = len(members) > 0;
    has_meetings: bool = len(meetings) > 0;
    tab_members_cls: str = "px-4 py-2 rounded-lg font-medium text-sm transition-colors " + ("bg-primary text-primary-foreground" if active_tab == "members" else "text-muted-foreground hover:bg-muted");
    tab_meetings_cls: str = "px-4 py-2 rounded-lg font-medium text-sm transition-colors " + ("bg-primary text-primary-foreground" if active_tab == "meetings" else "text-muted-foreground hover:bg-muted");
    tab_schedule_cls: str = "px-4 py-2 rounded-lg font-medium text-sm transition-colors " + ("bg-primary text-primary-foreground" if active_tab == "schedule" else "text-muted-foreground hover:bg-muted");

    return <div className="min-h-screen bg-background p-4 md:p-8">
        <div className="max-w-4xl mx-auto flex flex-col gap-6">
            <div className="text-center flex flex-col gap-2">
                <h1 className="text-3xl md:text-4xl font-bold text-foreground">📅 Meeting Planner</h1>
                <p className="text-muted-foreground">Schedule meetings and assign roles</p>
            </div>

            <div className="flex gap-2 bg-muted p-1 rounded-xl w-fit">
                <button onClick={lambda(e: MouseEvent) -> None { active_tab = "members"; }} className={tab_members_cls}>
                    👥 Members
                </button>
                <button onClick={lambda(e: MouseEvent) -> None { active_tab = "meetings"; }} className={tab_meetings_cls}>
                    📅 Meetings
                </button>
                <button onClick={lambda(e: MouseEvent) -> None { active_tab = "schedule"; }} className={tab_schedule_cls}>
                    📋 Schedule
                </button>
            </div>

            {active_tab == "members" and <div className="flex flex-col gap-4">
                <div className="rounded-xl border border-border bg-card p-6">
                    <h2 className="text-lg font-semibold mb-4">Add Member</h2>
                    <div className="flex gap-3">
                        <input
                            type="text"
                            value={new_member}
                            onChange={handle_member_change}
                            onKeyDown={handle_member_key}
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
                    <p className="text-4xl mb-3">👥</p>
                    <p className="text-muted-foreground">No members yet. Add your club members above.</p>
                </div>}

                {has_members and <div className="rounded-xl border border-border bg-card p-6">
                    <h2 className="text-lg font-semibold mb-4">{"Club Members (" + str(len(members)) + ")"}</h2>
                    <div className="flex flex-col gap-2">
                        {[<div key={str(i)} className="flex items-center justify-between p-3 rounded-lg bg-muted">
                            <div className="flex items-center gap-3">
                                <div className="w-8 h-8 rounded-full bg-primary text-primary-foreground flex items-center justify-center font-bold text-sm">
                                    {str(members[i]["name"])[0].upper()}
                                </div>
                                <span className="font-medium">{str(members[i]["name"])}</span>
                            </div>
                            <button
                                onClick={lambda(e: MouseEvent) -> None { remove_member(i); }}
                                className="text-muted-foreground hover:text-destructive transition-colors text-sm"
                            >
                                ✕
                            </button>
                        </div> for i in range(len(members))]}
                    </div>
                </div>}
            </div>}

            {active_tab == "meetings" and <div className="flex flex-col gap-4">
                <div className="rounded-xl border border-border bg-card p-6">
                    <h2 className="text-lg font-semibold mb-4">Create Meeting</h2>
                    <div className="flex flex-col gap-3">
                        <input
                            type="date"
                            value={new_date}
                            onChange={handle_date_change}
                            className="w-full p-3 rounded-lg border border-input bg-background text-foreground text-base"
                        />
                        <input
                            type="text"
                            value={new_theme}
                            onChange={handle_theme_change}
                            placeholder="Meeting theme (optional)..."
                            className="w-full p-3 rounded-lg border border-input bg-background text-foreground text-base"
                        />
                        <button
                            onClick={add_meeting}
                            className="px-6 py-3 rounded-lg bg-primary text-primary-foreground font-semibold hover:opacity-90 transition-opacity"
                        >
                            + Create Meeting
                        </button>
                    </div>
                </div>

                {not has_meetings and <div className="rounded-xl border border-border bg-card p-12 text-center">
                    <p className="text-4xl mb-3">📅</p>
                    <p className="text-muted-foreground">No meetings yet. Create one above.</p>
                </div>}

                {has_meetings and <div className="rounded-xl border border-border bg-card p-6">
                    <h2 className="text-lg font-semibold mb-4">Upcoming Meetings</h2>
                    <div className="flex flex-col gap-2">
                        {[<div key={str(i)} className={cn(["flex items-center justify-between p-3 rounded-lg cursor-pointer transition-colors",
                            "bg-primary/10 border border-primary" if selected_meeting == i else "bg-muted hover:bg-muted/80"
                        ])} onClick={lambda(e: MouseEvent) -> None { select_meeting(i); active_tab = "schedule"; }}>
                            <div className="flex flex-col gap-1">
                                <span className="font-medium">{str(meetings[i]["date"])}</span>
                                <span className="text-sm text-muted-foreground">{"Theme: " + str(meetings[i]["theme"]) if meetings[i]["theme"] else "No theme set"}</span>
                            </div>
                            <div className="flex items-center gap-2">
                                <span className="text-xs text-muted-foreground">Click to assign roles →</span>
                                <button
                                    onClick={lambda(e: MouseEvent) -> None { e.stopPropagation(); remove_meeting(i); }}
                                    className="text-muted-foreground hover:text-destructive transition-colors"
                                >
                                    ✕
                                </button>
                            </div>
                        </div> for i in range(len(meetings))]}
                    </div>
                </div>}
            </div>}

            {active_tab == "schedule" and selected_meeting >= 0 and selected_meeting < len(meetings) and <div className="flex flex-col gap-4">
                <div className="rounded-xl border border-border bg-primary/5 p-4">
                    <div className="flex items-center justify-between">
                        <div>
                            <h2 className="text-lg font-semibold">{"Meeting: " + str(meetings[selected_meeting]["date"])}</h2>
                            <p className="text-sm text-muted-foreground">{"Theme: " + str(meetings[selected_meeting]["theme"]) if meetings[selected_meeting]["theme"] else "No theme"}</p>
                        </div>
                        <button
                            onClick={lambda(e: MouseEvent) -> None { active_tab = "meetings"; }}
                            className="text-sm text-muted-foreground hover:text-foreground"
                        >
                            ← Back
                        </button>
                    </div>
                </div>

                {not has_members and <div className="rounded-xl border border-border bg-card p-6 text-center">
                    <p className="text-muted-foreground">Add members first to assign roles.</p>
                    <button
                        onClick={lambda(e: MouseEvent) -> None { active_tab = "members"; }}
                        className="mt-3 px-4 py-2 rounded-lg bg-primary text-primary-foreground text-sm font-medium"
                    >
                        Go to Members
                    </button>
                </div>}

                {has_members and <div className="rounded-xl border border-border bg-card p-6">
                    <h2 className="text-lg font-semibold mb-4">Role Assignments</h2>
                    <div className="flex flex-col gap-3">
                        {[<div key={str(k)} className="flex items-center gap-3">
                            <div className="w-48 shrink-0">
                                <span className="text-sm font-medium text-foreground">{str(ROLES[k])}</span>
                            </div>
                            <select
                                value={str(meetings[selected_meeting]["roles"][ROLES[k]])}
                                onChange={lambda(e: ChangeEvent) -> None { assign_role(selected_meeting, str(ROLES[k]), e.target.value); }}
                                className="flex-1 p-2 rounded-lg border border-input bg-background text-foreground text-sm"
                            >
                                <option value="">— Unassigned —</option>
                                {[<option key={str(m)} value={str(members[m]["name"])}>{str(members[m]["name"])}</option> for m in range(len(members))]}
                            </select>
                        </div> for k in range(len(ROLES))]}
                    </div>
                </div>}
            </div>}

            {active_tab == "schedule" and selected_meeting == -1 and <div className="rounded-xl border border-border bg-card p-12 text-center">
                <p className="text-4xl mb-3">📋</p>
                <p className="text-muted-foreground">Select a meeting from the Meetings tab to assign roles.</p>
                <button
                    onClick={lambda(e: MouseEvent) -> None { active_tab = "meetings"; }}
                    className="mt-4 px-4 py-2 rounded-lg bg-primary text-primary-foreground text-sm font-medium"
                >
                    Go to Meetings
                </button>
            </div>}
        </div>
    </div>;
}
