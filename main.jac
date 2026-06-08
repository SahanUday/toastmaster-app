import from services.planner {
    ClubMember, Meeting,
    get_planner_data, add_planner_member, remove_planner_member,
    add_planner_meeting, remove_planner_meeting, assign_meeting_role
}

import from services.progress {
    ProgressMember,
    get_progress_data, add_progress_member, remove_progress_member, toggle_progress_speech
}

cl {
    import from .frontend { app as ClientApp }

    def:pub app() -> JsxElement {
        return <ClientApp />;
    }
}
