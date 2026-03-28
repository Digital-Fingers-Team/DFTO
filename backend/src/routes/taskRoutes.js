const express = require("express");
const authMiddleware = require("../middleware/authMiddleware");
const {
  createPersonalTask,
  getPersonalTasks,
  createTeamTask,
  getTeamTasks,
  markTaskCompleted,
  approveTask,
} = require("../controllers/taskController");

const router = express.Router();

router.use(authMiddleware);

router.post("/personal", createPersonalTask);
router.get("/personal", getPersonalTasks);
router.post("/team", createTeamTask);
router.get("/team/:teamId", getTeamTasks);
router.patch("/:taskId/complete", markTaskCompleted);
router.patch("/:taskId/approve", approveTask);

module.exports = router;
