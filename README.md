## Requirements

- Ruby 3.0 or higher

## Usage

### Running with example data

```bash
ruby scheduler.rb
```

### Running with custom data

```bash
ruby scheduler.rb --data path_to_your/data.json
```

## Data Format

If you want to use your ownt json file with custom data, use this sctructure:

```json
{
  "buildings": [
    {
      "type": "single_story",
      "name": "123 Address st"
    },
    {
      "type": "two_story",
      "name": "456 Address st"
    }
  ],
  "employees": [
    {
      "type": "certified",
      "name": "John",
      "availability": [true, true, true, true, true]
    },
    {
      "type": "pending",
      "name": "Lisa",
      "availability": [true, false, true, true, true]
    }
  ]
}
```

### Building Types

- `single_story`
- `two_story`
- `commercial`

### Employee Types

- `certified`
- `pending`
- `laborer`

### Availability
Five days, true` means available, `false` means unavailable.

## Testing
To run the main service test:

```bash
ruby -Ilib:test test/scheduling_service_test.rb
```

Or to run the complete test suite:
```bash
ruby -I lib -e "Dir.glob('./test/*_test.rb').each { |file| require file }"
```

## Edge cases
**Multiple day Projects**: installations are assumed to one day, as per the requirements.

## Improvements
- A  strategy patter could be added to handle the different buildingi requirements
- Refactor SchedulingService to achieve better compartmentalization and single responsibilities.
For example move the ```assing_employees_to_building``` logic to its own service 

