# Api Synonyms
# Fitune-Challenge

* Ruby version 3.2.2

* System dependencies

  rails version 7.0.8

  postgresql version 16.1

* Deploy

### Graphql query

```
query {
  Media(id: 5) {
    id
    title {
      romaji
      english
      native
      userPreferred
    }
    format
    episodes
    description
    startDate {
      year
      month
      day
    }
    endDate {
      year
      month
      day
    }
    characters {
      nodes {
        id
        name {
          full
        }
        gender
        image {
          large
        }
      }
    }
  }
}

```

### View for One Level of Synonyms

```
CREATE VIEW Synonyms_View AS
SELECT w.reference AS word, s.reference AS synonym
FROM words w
JOIN synonyms s ON w.id = s.word_id
WHERE w.reference = 'good';

SELECT * FROM synonyms_view 

```

```
CREATE VIEW Synonyms_Count_View AS
SELECT w.reference AS word, COUNT(s.word_id) AS number
FROM words w
LEFT OUTER JOIN synonyms s ON w.id = s.word_id
WHERE w.reference = 'good' AND s.status = 0
GROUP BY w.reference;

SELECT * FROM synonyms_count_view

```