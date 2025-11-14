class Solution {
    public int uniquePathsWithObstacles(int[][] grid) {
        int m = grid.length;
        int n = grid[0].length;

        int[] dp = new int[n];

        if (grid[0][0] == 1) return 0;

        dp[0] = 1; 

        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {

                
                if (grid[i][j] == 1) {
                    dp[j] = 0;
                    continue;
                }

                
                if (j > 0) {
                    dp[j] += dp[j - 1];
                }
            }
        }

        return dp[n - 1];
    }
}
