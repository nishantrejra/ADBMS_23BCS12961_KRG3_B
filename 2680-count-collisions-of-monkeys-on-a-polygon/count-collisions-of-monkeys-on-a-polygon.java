class Solution {
    static final long MOD = 1000000007  ;
    public int monkeyMove(int n) {
        long totalWays = findPower(2, n, MOD);
        long collisions = (totalWays - 2 + MOD) % MOD;
        return (int) collisions;
    }

    private long findPower(long base, long exp, long mod) {
        long result = 1;

        while (exp > 0) {
            if ((exp % 2) == 1) {      
                result = (result * base) % mod;
            }
            base = (base * base) % mod;
            exp = exp/2;                  
        }

        return result;
    }
}