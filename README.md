# mf-data

A comprehensive data engineering repository for storing and managing SQL queries, views, and data transformations for various BI use cases across multiple platforms.

## 🏗️ Repository Structure

```
mf-data/
├── bigquery/                 # BigQuery specific queries and objects
│   ├── views/               # View definitions
│   ├── tables/              # Table creation and manipulation scripts
│   ├── functions/           # User-defined functions
│   └── procedures/          # Stored procedures
├── scripts/                 # Deployment and utility scripts
├── config/                  # Configuration files for different environments
├── docs/                    # Documentation and best practices
└── examples/                # Example queries and templates
```

## 🚀 Getting Started

### Prerequisites
- Access to BigQuery or your target data platform
- Appropriate permissions for creating/modifying database objects
- Git for version control

### Usage
1. Clone this repository
2. Navigate to the appropriate platform directory (e.g., `bigquery/`)
3. Choose the type of object you want to work with (views, tables, functions, procedures)
4. Use the provided templates or existing queries as starting points

## 📝 Conventions

### File Naming
- Use lowercase with underscores: `customer_metrics_view.sql`
- Include descriptive names that indicate purpose
- Add prefixes for environment-specific queries: `prod_`, `dev_`, `staging_`

### Query Organization
- Group related queries in subdirectories by domain (e.g., `marketing/`, `finance/`, `operations/`)
- Include comments explaining the purpose and business logic
- Document data sources and dependencies

## 🔧 Configuration

Configuration files in the `config/` directory allow for environment-specific settings:
- Database connections
- Schema names
- Resource allocation settings

## 📚 Documentation

See the `docs/` directory for:
- Best practices for SQL development
- Deployment guidelines
- Data governance policies
- Performance optimization tips

## 🤝 Contributing

1. Create feature branches for new queries or modifications
2. Follow the established naming conventions
3. Include appropriate documentation and comments
4. Test queries in development environment before merging

## 📊 Platform Support

Currently supports:
- **BigQuery** - Primary platform for data warehousing
- Extensible for other platforms (Snowflake, Redshift, etc.)

## 📄 License

[Add your license information here]
