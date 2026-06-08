node ProgressMember {
    has name: str;
    has speeches: dict = {};
}

def:pub get_progress_data() -> list {
    result: list = [];
    for m in [root -->][?:ProgressMember] {
        result.append({"id": jid(m), "name": m.name, "speeches": m.speeches});
    }
    return result;
}

def:pub add_progress_member(name: str, speeches: dict) -> list {
    new_m: ProgressMember = (root ++> ProgressMember(name=name, speeches=speeches))[0];
    return get_progress_data();
}

def:pub remove_progress_member(member_id: str) -> list {
    for m in [root -->][?:ProgressMember] {
        if jid(m) == member_id {
            del m;
            return get_progress_data();
        }
    }
    return get_progress_data();
}

def:pub toggle_progress_speech(member_id: str, speech: str) -> list {
    for m in [root -->][?:ProgressMember] {
        if jid(m) == member_id {
            m.speeches[speech] = not bool(m.speeches[speech]);
            return get_progress_data();
        }
    }
    return get_progress_data();
}
