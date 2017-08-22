# Queryable API Challenge

An internal API for a national healthcare provider (a code challenge).

[Deployed Application](https://queryable-api-challenge.herokuapp.com/) 

## Getting Started

### Prerequisites

You will need to have `Rails 5` and `Ruby 2.4.1` and `PostgreSQL` up and running in order to run this application locally.

If you're unfamiliar with Ruby or Rails, [check out the Rails Getting Started Documentation](http://guides.rubyonrails.org/getting_started.html)

### Installing

Pull down this repository

```
git@github.com:rrgayhart/queryable_api.git
```

Install dependencies

```
bundle install
```

Set up the database

Note: running `rake db:seed` will require an internet connection and will take some time.

```
rake db:create
rake db:migrate
rake db:test:prepare
```

Run the tests

```
rspec
```

Start the server

```
rails s
```

## Implementation Notes

#### Technology Used

- Language
  - [Ruby](https://www.ruby-lang.org) 2.4.1
- Framework
  - [Rails](http://rubyonrails.org/) ~> 5.1.2
- Database
  - [PostgreSQL](https://www.postgresql.org/) through the [pg gem](https://rubygems.org/gems/pg/versions/0.18.4) (still using Active Record as the ORM)
- Testing
  - [rspec](http://rspec.info/) through the [rspec-rails](https://github.com/rspec/rspec-rails) gem
  - [factory_girl_rails](https://github.com/thoughtbot/factory_girl_rails) 
  - [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)

#### Provider Schema

Data was provided in the form for this [Data Set CSV](https://s3-us-west-2.amazonaws.com/bain-coding-challenge/Inpatient_Prospective_Payment_System__IPPS__Provider_Summary_for_the_Top_100_Diagnosis-Related_Groups__DRG__-_FY2011.csv)

```rb
  create_table "providers", force: :cascade do |t|
    t.string "provider_name"
    t.string "provider_street_address"
    t.string "provider_city"
    t.string "provider_state"
    t.string "provider_zip_code"
    t.string "hospital_referral_region_description"
    t.integer "total_discharges"
    t.string "average_covered_charges"
    t.string "average_total_payments"
    t.string "average_medicare_payments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
```

As there was a direct match between the naming of things like `:provider_street_address' as a header in the CSV and `Provider Street Address` as a key in the expected output - I chose to keep that naming convention in the database columns.

If this project were to expand, I would consider:
- refactoring out references to 'provider' in table names
- spliting address into it's own table
- storing `provider_id` for deduplication accross multiple CSVs

#### Deploying to Heroku

I chose to try and seed the CSV data directly from the [link provided](https://s3-us-west-2.amazonaws.com/bain-coding-challenge/Inpatient_Prospective_Payment_System__IPPS__Provider_Summary_for_the_Top_100_Diagnosis-Related_Groups__DRG__-_FY2011.csv) rather than including the CSV in the project git history.

I was able to run the CSV seeding process in a [detached state](https://devcenter.heroku.com/articles/one-off-dynos#running-tasks-in-background) to try and avoid timeouts using: `heroku run:detached rake db:seed`.

## Requirements

- [Data Set CSV](https://s3-us-west-2.amazonaws.com/bain-coding-challenge/Inpatient_Prospective_Payment_System__IPPS__Provider_Summary_for_the_Top_100_Diagnosis-Related_Groups__DRG__-_FY2011.csv)

- An API endpoint that implements the url ending with `/providers`
- Every possible combination of query string parameters works
- Some datastore is used
- Your API returns valid JSON
- Automated tests (i.e. tests that can be run from command line)
- A writeup/README describing your architecture, solutions, and assumptions made. Be as thorough as possible with your explination.
- Deployed
- If you're having problems with database size on Heroku, use a smaller subset of the data and indicate it in your writeup. Also provide example queries to this

## API:

```
GET /providers?max_discharges=5&min_discharges=6&max_average_covered_charges=50000
&min_average_covered_charges=40000&min_average_medicare_payments=6000
&max_average_medicare_payments=10000&state=GA
```

| Parameter                       | Description                               |
|---------------------------------|-------------------------------------------|
| `max_discharges`                | The maximum number of Total Discharges    |
| `min_discharges`                | The minimum number of Total Discharges    |
| `max_average_covered_charges`   | The maximum Average Covered Charges       | 
| `min_average_covered_charges`   | The minimum Average Covered Charges       |
| `max_average_medicare_payments` | The maximum Average Medicare Payment      |
| `min_average_medicare_payments` | The minimum Average Medicare Payment      |
| `state`                         | The exact state that the provider is from |


#### The expected response is a JSON blob containing the list of providers meeting the criteria.  All query parameters are optional.  Min and Max fields are inclusive

```json
[
  {
    "Provider Name": "SOUTHEAST ALABAMA MEDICAL CENTER",
    "Provider Street Address": "1108 ROSS CLARK CIRCLE",
    "Provider City": "DOTHAN",
    "Provider State": "AL",
    "Provider Zip Code": "36301", 
    "Hospital Referral Region Description": "AL - Dothan",
    "Total Discharges": 91,
    "Average Covered Charges": "$32,963.07", 
    "Average Total Payments":   "$5,777.24",
    "Average Medicare Payments": "$4,763.73"
  },
  {
    "Provider Name": "MARSHALL MEDICAL CENTER SOUTH",
    "Provider Street Address": "2505 U S HIGHWAY 431 NORTH",
    "Provider City": "BOAZ",
    "Provider State": "AL",
    "Provider Zip Code": "35957", 
    "Hospital Referral Region Description": "AL - Birmingham",
    "Total Discharges": 14,
    "Average Covered Charges": "$32,963.07", 
    "Average Total Payments":   "$5,777.24",
    "Average Medicare Payments": "$4,763.73"
  }
  
]

```