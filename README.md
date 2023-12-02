# Api Synonyms
# Fitune-Challenge

* Ruby version 3.2.2

* System dependencies

  rails version 7.0.8

  postgresql version 16.1

* Deployment instructions
  http://synonymsapi.fly.dev/api-docs/index.html

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

### View for One Level of Synonyms (Synonyms_Synonyms_VIEW)

```
CREATE VIEW Synonyms_Synonyms_VIEW AS
SELECT DISTINCT w.reference AS word, s.synonym AS synonym
FROM words w
JOIN synonyms s ON w.id = s.word_id;

```

### View for the Last Level of Synonyms (Synonyms_Synonyms_VIEW2)

```
CREATE VIEW Synonyms_Synonyms_VIEW2 AS
WITH RECURSIVE RecursiveSynonyms AS (
  SELECT w.reference AS word, s.synonym, 1 AS level
  FROM words w
  JOIN synonyms s ON w.id = s.word_id
  UNION ALL
  SELECT rs.word, s.synonym, rs.level + 1
  FROM RecursiveSynonyms rs
  JOIN synonyms s ON rs.synonym = s.word_id
)
SELECT word, synonym
FROM RecursiveSynonyms
WHERE level = (SELECT MAX(level) FROM RecursiveSynonyms);
```