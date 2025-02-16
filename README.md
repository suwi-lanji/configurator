# Configurator

### Available for hire email | suwilanji@inongo.space. Linked In Suwilanji Chipofya

**Configurator** is a command-line tool that generates Laravel Eloquent migrations from YAML or JSON configuration files. It simplifies the process of defining database schemas and automates the creation of migration files for Laravel applications.

---

## Features

- **Supports Multiple Formats**: Works with YAML and JSON configuration files.
- **Customizable**: Define table names, columns, data types, and constraints in a simple configuration file.
- **Scalable**: Generates migrations for multiple tables and relationships.
- **Error Handling**: Provides clear warnings and skips invalid configurations.

---

## Installation

### 1. Install Ruby

Ensure you have Ruby installed on your system. You can check your Ruby version by running:

```bash
ruby -v
```

If Ruby is not installed, follow the official [Ruby installation guide](https://www.ruby-lang.org/en/documentation/installation/).

### 2. Install the Gem

You can install the `configurator` gem directly from the source:

```bash
gem install config-to-laravel-migrations
```

Alternatively, clone the repository and build the gem locally:

```bash
git clone https://github.com/suwi-lanji/configurator.git
cd configurator
gem build configurator.gemspec
gem install configurator-1.0.0.gem
```

---

## Usage

### 1. Create a Configuration File

Define your database schema in a YAML or JSON file. Here’s an example `school_managementsystem.yml` file:

```yaml
User:
  table_name: users
  attributes:
    user_id: { type: int, primary_key: true }
    username: { type: string, unique: true }
    password_hash: { type: string }
    email: { type: string, unique: true }
    role_id: { type: int, foreign_key: roles.role_id }
    institution_id: { type: int, foreign_key: institutions.institution_id }

Role:
  table_name: roles
  attributes:
    role_id: { type: int, primary_key: true }
    role_name: { type: string, unique: true }
```

### 2. Generate Migrations

Run the `configurator` command with your configuration file:

```bash
configurator generate school_managementsystem.yml migrations
```

This will generate Laravel migration files in the `migrations` directory.

---

## Example Output

For the above configuration, the tool will generate the following files:

#### `migrations/20250210120000_create_users_table.php`

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUserTable extends Migration
{
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->integer('user_id');
            $table->string('username')->unique();
            $table->string('password_hash');
            $table->string('email')->unique();
            $table->integer('role_id');
            $table->foreignId('institution_id');
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('users');
    }
}
```

#### `migrations/20250210120001_create_roles_table.php`

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateRoleTable extends Migration
{
    public function up()
    {
        Schema::create('roles', function (Blueprint $table) {
            $table->id();
            $table->integer('role_id');
            $table->string('role_name')->unique();
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('roles');
    }
}
```

---

## Configuration File Format

### YAML Format

```yaml
ModelName:
  table_name: table_name
  attributes:
    column_name:
      type: data_type
      primary_key: true/false
      unique: true/false
      foreign_key: referenced_table.referenced_column
```

### JSON Format

```json
{
  "ModelName": {
    "table_name": "table_name",
    "attributes": {
      "column_name": {
        "type": "data_type",
        "primary_key": true/false,
        "unique": true/false,
        "foreign_key": "referenced_table.referenced_column"
      }
    }
  }
}
```

---

## Supported Data Types

The following data types are supported:

- `int` → `integer`
- `string` → `string`
- `date` → `date`
- `datetime` → `datetime`
- `float` → `float`
- `enum` → `enum`

---

## Contributing

Contributions are welcome! Follow these steps to contribute:

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Commit your changes and push to the branch.
4. Submit a pull request.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Support

If you encounter any issues or have questions, please open an issue on the [GitHub repository](https://github.com/suwi-lanji/configurator/issues).

---

## Author

- **Suwilanji Jack Chipofya**  
  GitHub: [suwi-lanji](https://github.com/suwi-lanji)  
  Email: suwilanji@inongo.space

---

Enjoy using **Configurator**! 🚀
