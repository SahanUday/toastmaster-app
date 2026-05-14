import from ..components.ui.button { Button }

def:pub Counter(props: dict) -> JsxElement {
    has count: int = 0;

    return <Button
        onClick={lambda(e: any) -> None { count = count + 1; }}
    >
        {"count is " + str(count)}
    </Button>;
}

