const express = require("express");
const authMiddleware = require("../middleware/authMiddleware");
const {
  createTeam,
  joinTeam,
  getMyTeam,
  getTeamById,
  getLeaderboard,
} = require("../controllers/teamController");

const router = express.Router();

router.use(authMiddleware);
router.post("/", createTeam);
router.get("/my", getMyTeam);
router.post("/join/:inviteCode", joinTeam);
router.get("/:teamId", getTeamById);
router.get("/:teamId/leaderboard", getLeaderboard);

module.exports = router;
