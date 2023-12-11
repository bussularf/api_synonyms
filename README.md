# Api Synonyms

* Ruby version 3.2.2

* System dependencies

  rails version 7.0.8

  postgresql version 16.1

* Deploy
  http://api-synonyms-5ba648b892a3.herokuapp.com/api-docs/index.html

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

<table>
  <tr>
    <td><img src="/images/view1.png" alt="View 1"></td>
    <td><img src="/images/view2.png" alt="View 2"></td>
  </tr>
</table>

<img src="/images/root.png">
<img src="/images/login.png">
<img src="/images/index.png">
<img src="/images/create.png">
<img src="/images/review.png">
<img src="/images/authorize.png">
<img src="/images/delete.png">

