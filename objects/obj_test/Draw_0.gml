shader_set(shd_lighting);
shader_set_uniform_f("u_GlobalLight", 0, 1);
draw_self();
shader_reset();
