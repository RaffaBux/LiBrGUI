using Gtk
using LiBr

function build_gui()
    # Create window & layout
    win   = GtkWindow("LiBr Properties Calculator", 600, 800)
    vbox  = GtkBox(:v; spacing=8)
    push!(win, vbox)


    # Row 1: x, T, p
    h1    = GtkBox(:h; spacing=8)
    set_gtk_property!(h1, :margin,      10)
    set_gtk_property!(h1, :margin,      10)

    lbl_x = GtkLabel("x [%]:")
    ent_x = GtkEntry(text="60.0")

    lbl_T = GtkLabel("T [K]:")
    ent_T = GtkEntry(text="298.15")

    lbl_p = GtkLabel("p [kPa]:")
    ent_p = GtkEntry(text="1000.0")

    push!(h1, lbl_x, ent_x, lbl_T, ent_T, lbl_p, ent_p)
    push!(vbox, h1)


    # Row 2: h, s
    h2    = GtkBox(:h; spacing=8)
    set_gtk_property!(h2, :margin,      10)
    set_gtk_property!(h2, :margin,      10)


    lbl_h = GtkLabel("h [J/g]:")
    ent_h = GtkEntry(text="10000.0")

    lbl_s = GtkLabel("s [J/g·K]:")
    ent_s = GtkEntry(text="50.0")

    push!(h2, lbl_h, ent_h, lbl_s, ent_s)
    push!(vbox, h2)


    # Compute button
    btn = GtkButton("Compute")
    push!(vbox, btn)

    # Results area
    txtbuf  = GtkTextBuffer()
    txtview = GtkTextView(buffer=txtbuf)
    set_gtk_property!(txtview, :editable, false)
    scroller = GtkScrolledWindow()
    set_gtk_property!(scroller, :margin, 10)
    set_gtk_property!(scroller, :hexpand, true)
    set_gtk_property!(scroller, :vexpand, true)
    push!(scroller, txtview)
    push!(vbox, scroller)

    # Button callback
    signal_connect(btn, "clicked") do _
        x = try
            get_gtk_property(ent_x, :text, String) |> (str -> parse(Float64, str))
        catch err
            set_gtk_property!(txtbuf, :text, "Invalid x: $(err.msg)") 
            return
        end

        T = try
            get_gtk_property(ent_T, :text, String) |> (str -> parse(Float64, str))
        catch err
            set_gtk_property!(txtbuf, :text, "Invalid T: $(err.msg)") 
            return
        end

        p = try
            get_gtk_property(ent_p, :text, String) |> (str -> parse(Float64, str))
        catch err
            set_gtk_property!(txtbuf, :text, "Invalid p: $(err.msg)") 
            return
        end

        h = try
            get_gtk_property(ent_h, :text, String) |> (str -> parse(Float64, str))
        catch err
            set_gtk_property!(txtbuf, :text, "Invalid h: $(err.msg)") 
            return
        end

        s = try
            get_gtk_property(ent_s, :text, String) |> (str -> parse(Float64, str))
        catch err
            set_gtk_property!(txtbuf, :text, "Invalid s: $(err.msg)") 
            return
        end

        props = [
            ("Thermal conductivity [W/m·K]",            () -> libr_k(x, T)),
            ("Enthalpy [J/g]",                          () -> libr_h(x, T, p)),
            ("Entropy [J/g·K]",                         () -> libr_s(x, T, p)),
            ("Specific heat [J/g·K]",                   () -> libr_cp(x, T, p)),
            ("Dynamic viscosity [cP]",                  () -> libr_μ(x, T)),
            ("Chemical potential of water [J/g]",       () -> libr_uw(x, T, p)),
            ("libr_u (?????)",                          () -> libr_u(x, T, p)),
            ("Chemical potential of LiBr [J/g]",        () -> libr_us(x, T, p)),
            ("Volume [m^3/kg]",                         () -> libr_v(x, T, p)),
            ("Saturation pressure [kPa]",               () -> libr_p(x, T)),
            ("Saturation temperature [K]",              () -> libr_t(x, p)),
            ("Saturation mass fraction [---]",          () -> libr_x(T, p)),
            ("Crystallization temperature [°C]",        () -> libr_tcryst(x)),
            ("Flashing process [---]",                  () -> libr_flash(x, h, p)),
            ("Index of refraction [---]",               () -> libr_refindex(x, T)),
            ("Partial mass Gibbs function [J/g]",       () -> libr_part_g(x, T, p)),
            ("Partial mass enthalpy [J/g]",             () -> libr_part_h(x, T, p)),
            ("Partial mass entropy [J/g·K]",            () -> libr_part_s(x, T, p)),
            ("Partial mass volume [m^3/kg]",            () -> libr_part_v(x, T)),
            ("Temperature according Enthalpy [K]",      () -> libr_xht(x, h, p)),
            ("Mass faction according Enthalpy [%]",     () -> libr_htx(h, T, p)),
            ("Temperature according entropy [K]",       () -> libr_xst(x, s, p)),
            ("Mass faction according entropy [%]",      () -> libr_stx(s, T, p))
        ]

        results = String[]
        for (label, fn) in props
            val = try fn() catch _; "ERROR" end
            push!(results, "$label: $val")
        end

        set_gtk_property!(txtbuf, :text, join(results, "\n"))
    end

    # When the user closes the window, quit gtk_main()
    signal_connect(win, "destroy") do _ 
        Gtk.gtk_main_quit() 
    end

    showall(win)
    return win
end

# Build the GUI and start GTK’s loop
win = build_gui()

# Block until the window is destroyed:
c = Condition()
signal_connect(win, "destroy") do _
    notify(c)
end
wait(c)