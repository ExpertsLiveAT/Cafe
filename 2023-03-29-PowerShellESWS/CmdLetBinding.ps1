function Show-Binding {
    # [CmdLetBinding()]
    param(
        $a,
        $b
    )

    "a = $a b = $b args = $args"
}