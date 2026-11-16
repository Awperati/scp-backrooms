import os
from PIL import Image, ImageDraw

# Create placeholder textures directory if it doesn't exist
placeholder_dir = "assets/textures/placeholder"
os.makedirs(placeholder_dir, exist_ok=True)

# Create floor texture (grid pattern)
def create_floor_texture():
    img = Image.new('RGBA', (64, 64), color=(100, 100, 100, 255))
    draw = ImageDraw.Draw(img)
    
    # Draw grid pattern
    for x in range(0, 64, 8):
        for y in range(0, 64, 8):
            if (x // 8 + y // 8) % 2 == 0:
                draw.rectangle([x, y, x+7, y+7], fill=(80, 80, 80, 255))
    
    img.save(os.path.join(placeholder_dir, "floor.png"))
    print("Created floor.png")

# Create wall texture (dark gray with pattern)
def create_wall_texture():
    img = Image.new('RGBA', (64, 64), color=(50, 50, 50, 255))
    draw = ImageDraw.Draw(img)
    
    # Draw brick pattern
    for x in range(0, 64, 16):
        for y in range(0, 64, 16):
            draw.rectangle([x, y, x+15, y+15], fill=(40, 40, 40, 255))
            draw.rectangle([x+2, y+2, x+13, y+13], fill=(60, 60, 60, 255))
    
    img.save(os.path.join(placeholder_dir, "wall.png"))
    print("Created wall.png")

# Create data drive texture
def create_data_drive_texture():
    img = Image.new('RGBA', (32, 32), color=(200, 200, 200, 255))
    draw = ImageDraw.Draw(img)
    
    # Draw a simple drive shape with label
    draw.rectangle([4, 4, 28, 28], fill=(150, 150, 150, 255))
    draw.rectangle([8, 8, 24, 24], fill=(100, 100, 100, 255))
    draw.text((10, 10), "D", fill=(255, 255, 0, 255))
    
    img.save(os.path.join(placeholder_dir, "data_drive.png"))
    print("Created data_drive.png")

# Create exit door texture
def create_exit_door_texture():
    img = Image.new('RGBA', (64, 32), color=(150, 100, 50, 255))
    draw = ImageDraw.Draw(img)
    
    # Draw door with handle
    draw.rectangle([0, 0, 63, 31], fill=(100, 70, 30, 255))
    draw.rectangle([50, 10, 55, 22], fill=(180, 180, 180, 255))
    
    img.save(os.path.join(placeholder_dir, "exit_door.png"))
    print("Created exit_door.png")

# Create player texture
def create_player_texture():
    img = Image.new('RGBA', (32, 32), color=(0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Draw simple player character (circle with eye)
    draw.ellipse([8, 8, 24, 24], fill=(200, 200, 200, 255))
    draw.ellipse([12, 12, 16, 16], fill=(0, 0, 0, 255))
    
    img.save(os.path.join(placeholder_dir, "player.png"))
    print("Created player.png")

# Generate all textures
if __name__ == "__main__":
    create_floor_texture()
    create_wall_texture()
    create_data_drive_texture()
    create_exit_door_texture()
    create_player_texture()
    print("All placeholder textures created!")