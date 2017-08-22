# Queryable API Challenge

An internal API for a national healthcare provider (a code challenge).

[Deployed Application](https://queryable-api-challenge.herokuapp.com/) 

![gif of working application](http://g.recordit.co/OBnD8hF54o.gif)

## Accessing the API

| Parameter                       | Description                               |
|---------------------------------|-------------------------------------------|
| `max_discharges`                | The maximum number of Total Discharges    |
| `min_discharges`                | The minimum number of Total Discharges    |
| `max_average_covered_charges`   | The maximum Average Covered Charges       | 
| `min_average_covered_charges`   | The minimum Average Covered Charges       |
| `max_average_medicare_payments` | The maximum Average Medicare Payment      |
| `min_average_medicare_payments` | The minimum Average Medicare Payment      |
| `state`                         | The exact state that the provider is from |

```
GET /providers?max_discharges=70&min_discharges=68&max_average_covered_charges=50000&min_average_covered_charges=45000&min_average_medicare_payments=6000&max_average_medicare_payments=10000&state=GA
```

```json
{
  meta: {
    total: 2,
    max_shown: 100,
    page: "1"
  },
  data: [
    {
      Provider Name: "SPALDING REGIONAL MEDICAL CENTER",
      Provider Street Address: "601 SOUTH 8TH STREET",
      Provider City: "GRIFFIN",
      Provider State: "GA",
      Provider Zip Code: "30223",
      Hospital Referral Region Description: "GA - Atlanta",
      Total Discharges: 68,
      Average Covered Charges: "$45,824.38",
      Average Total Payments: "$9,260.82",
      Average Medicare Payments: "$8,049.48"
    },
    {
      Provider Name: "EMORY EASTSIDE MEDICAL CENTER",
      Provider Street Address: "1700 MEDICAL WAY",
      Provider City: "SNELLVILLE",
      Provider State: "GA",
      Provider Zip Code: "30078",
      Hospital Referral Region Description: "GA - Atlanta",
      Total Discharges: 68,
      Average Covered Charges: "$46,777.98",
      Average Total Payments: "$8,796.27",
      Average Medicare Payments: "$7,899.88"
    }
  ]
}

```

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

Start the server

```
rails s
```

### Testing

Run the tests

```
rspec
```

![tests running](http://g.recordit.co/Hic02GDrjx.gif)

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
  - [jbuilder](https://github.com/rails/jbuilder)
  - [will-paginate](https://github.com/mislav/will_paginate)

#### Provider Schema

Data was provided in the form for this [Data Set CSV](https://s3-us-west-2.amazonaws.com/bain-coding-challenge/Inpatient_Prospective_Payment_System__IPPS__Provider_Summary_for_the_Top_100_Diagnosis-Related_Groups__DRG__-_FY2011.csv)

```rb
    create_table :providers do |t|
      t.string :provider_name
      t.string :provider_street_address
      t.string :provider_city
      t.string :provider_state
      t.string :provider_zip_code
      t.string :hospital_referral_region_description
      t.integer :total_discharges
      t.decimal :average_covered_charges, :precision => 10, :scale => 2, :default => 0.0
      t.decimal :average_total_payments, :precision => 10, :scale => 2, :default => 0.0
      t.decimal :average_medicare_payments, :precision => 10, :scale => 2, :default => 0.0
      t.timestamps
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

## Deviations from the Requirements

#### Pagination

  Given the large quantity of records, a general query could return 163065 records. This would be an enormous response, so I paginated the responses and allowed the query to include a page parameter. Top level keys on the API responses are 'data' and 'meta' to reflect the total number of records/current page/etc.

#### Endpoints

  The spec requires `/providers` endpoint (which is present) - but I namespaced the controller and view under `api/v1` and provided a namespaced endpoint. I also routed the root to the providers index so as not to confuse anyone visiting the heroku site. A more elegant solution would probably have been to provide a splash page for the API with instructions for use and links to provided endpoints at the root.