const Task = require("../models/Task");
const User = require("../models/User");

const getDashboard = async (req, res) => {
  const userId = req.user._id;
  const user = await User.findById(userId).select("-password");

  const [personalPending, personalCompleted, teamPending, teamCompleted, teamApproved] =
    await Promise.all([
      Task.countDocuments({ type: "personal", assignedTo: userId, status: "pending" }),
      Task.countDocuments({ type: "personal", assignedTo: userId, status: "completed" }),
      Task.countDocuments({ type: "team", assignedTo: userId, status: "pending" }),
      Task.countDocuments({ type: "team", assignedTo: userId, status: "completed" }),
      Task.countDocuments({ type: "team", assignedTo: userId, status: "approved" }),
    ]);

  return res.json({
    user,
    stats: { personalPending, personalCompleted, teamPending, teamCompleted, teamApproved },
  });
};

module.exports = { getDashboard };
