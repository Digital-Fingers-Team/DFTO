import "dotenv/config";
import { MongoClient } from "mongodb";

const uri = process.env.MONGODB_URI;

if (!uri) {
  console.error("Missing MONGODB_URI in environment.");
  process.exit(1);
}

const client = new MongoClient(uri);

async function deleteAllData() {
  try {
    await client.connect();

    const adminDb = client.db("admin");
    const { databases } = await adminDb.admin().listDatabases();

    const systemDbs = new Set(["admin", "local", "config"]);
    const targets = databases
      .map((db) => db.name)
      .filter((name) => !systemDbs.has(name));

    if (targets.length === 0) {
      console.log("No non-system databases found. Nothing to delete.");
      return;
    }

    for (const dbName of targets) {
      await client.db(dbName).dropDatabase();
      console.log(`Dropped database: ${dbName}`);
    }

    console.log("All non-system databases were deleted.");
  } catch (error) {
    console.error("Deletion failed:", error.message);
    process.exitCode = 1;
  } finally {
    await client.close();
  }
}

deleteAllData();
