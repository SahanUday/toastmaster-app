node ClubMember {
    has name: str;
}

node Meeting {
    has date: str;
    has theme: str = "";
    has roles: dict = {};
}

def:pub get_planner_data() -> dict {
    members_list: list = [];
    for m in [root -->][?:ClubMember] {
        members_list.append({"id": jid(m), "name": m.name});
    }
    meetings_list: list = [];
    for mt in [root -->][?:Meeting] {
        meetings_list.append({"id": jid(mt), "date": mt.date, "theme": mt.theme, "roles": mt.roles});
    }
    return {"members": members_list, "meetings": meetings_list};
}

def:pub add_planner_member(name: str) -> dict {
    new_m: ClubMember = (root ++> ClubMember(name=name))[0];
    return get_planner_data();
}

def:pub remove_planner_member(member_id: str) -> dict {
    for m in [root -->][?:ClubMember] {
        if jid(m) == member_id {
            del m;
            return get_planner_data();
        }
    }
    return get_planner_data();
}

def:pub add_planner_meeting(date: str, theme: str) -> dict {
    new_mt: Meeting = (root ++> Meeting(date=date, theme=theme, roles={}))[0];
    return get_planner_data();
}

def:pub remove_planner_meeting(meeting_id: str) -> dict {
    for mt in [root -->][?:Meeting] {
        if jid(mt) == meeting_id {
            del mt;
            return get_planner_data();
        }
    }
    return get_planner_data();
}

def:pub assign_meeting_role(meeting_id: str, role: str, member_name: str) -> dict {
    for mt in [root -->][?:Meeting] {
        if jid(mt) == meeting_id {
            mt.roles[role] = member_name;
            return get_planner_data();
        }
    }
    return get_planner_data();
}
