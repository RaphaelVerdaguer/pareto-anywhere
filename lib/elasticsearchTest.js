const { Client } = require("@elastic/elasticsearch");
require('dotenv').config();  // Charger les variables d'environnement depuis le fichier .env

class ElasticsearchTest {
  constructor(elasticsearchNode) {
    const elasticsearchParetoApi =
      process.env.ELASTICSEARCH_PARETO_API;

    this.elasticsearchDataConApi = {
      node: elasticsearchNode,
      auth: {
        apiKey: elasticsearchParetoApi,
      },
      tls: {
        rejectUnauthorized: false,
      },
    };

    this.client = new Client(this.elasticsearchDataConApi);
  }

  async testConnection() {
    console.log("Test de connexion Elasticsearch:");
    console.log("elasticsearchDataConApi: ", this.elasticsearchDataConApi);

    try {
      // Let's start by indexing some data
      await this.client.index({
        index: "game-of-thrones",
        body: {
          character: "Ned Stark",
          quote: "Winter is coming.",
        },
      });

      await this.client.index({
        index: "game-of-thrones",
        body: {
          character: "Daenerys Targaryen",
          quote: "I am the blood of the dragon.",
        },
      });

      await this.client.index({
        index: "game-of-thrones",
        body: {
          character: "Tyrion Lannister",
          quote: "A mind needs books like a sword needs a whetstone.",
        },
      });

      // Force an index refresh to ensure we get results in the subsequent search
      await this.client.indices.refresh({ index: "game-of-thrones" });

      // Let's search!
      const result = await this.client.search({
        index: "game-of-thrones",
        body: {
          query: {
            match: { quote: "winter" },
          },
        },
      });

      console.log(result);
    } catch (error) {
      console.error(error);
      process.exit(1);
    }
  }
}

module.exports = ElasticsearchTest;
