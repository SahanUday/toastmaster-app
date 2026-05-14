import from "radix-ui" { AspectRatio as AspectRatioPrimitive }

def:pub AspectRatio(props: Any) -> JsxElement {
    return <AspectRatioPrimitive.Root data-slot="aspect-ratio" {...props} />;
}
