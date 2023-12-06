shader_type canvas_item;

void fragment() {
    // Get the color of the pixel from the texture.
    vec4 pixel = texture(TEXTURE, UV);

    // Get the blue component of the pixel color.
    float blue_component = pixel.b;

    // If the blue component is greater than 0.5, set the pixel color to red.
    if (blue_component > 0.7) {
        pixel.r = 0.8;
        pixel.g = 0.0;
        pixel.b = 0.0;
    }

    // Set the pixel color to the shader's output.
    COLOR = pixel;
}
