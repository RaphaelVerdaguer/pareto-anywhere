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

    try {
      // Indexer la date et l'heure du lancement du test
      const testTimestamp = new Date().toISOString();
      
      // Let's start by indexing some data
      await this.client.index({
        index: "game-of-thrones",
        body: {
          timestamp: testTimestamp,
          character: "Ned Stark",
          quote: "Winter is coming.",
        },
      });

      await this.client.index({
        index: "game-of-thrones",
        body: {
          timestamp: testTimestamp,
          character: "Daenerys Targaryen",
          quote: "I am the blood of the dragon.",
        },
      });

      await this.client.index({
        index: "game-of-thrones",
        body: {
          timestamp: testTimestamp,
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

      console.log("Test connection Elasticsearch OK!");
    } catch (error) {
      console.error("Test connection Elasticsearch FAIL!");
      console.error(error);
      process.exit(1);
    }
  }
}

module.exports = ElasticsearchTest;
