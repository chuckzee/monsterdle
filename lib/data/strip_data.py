import json

# Load the original data.
with open('monster_data.json', 'r') as f:
    data = json.load(f)

# Create a new list that only includes the 'name' field for each monster.
simplified_data = {
    'monsters': [{'name': monster['name']} for monster in data['monsters']]
}

# Then sort the simplified data alphabetically
simplified_data['monsters'].sort(key=lambda monster: monster['name'])

# Save the simplified data to a new file.
with open('simplified_monster_data.json', 'w') as f:
    json.dump(simplified_data, f)
