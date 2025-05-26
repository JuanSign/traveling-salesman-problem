#ifndef __SOLVER__
#define __SOLVER__

#include <utility>
#include <vector>

class SOLVER
{
public:
    static std::pair<std::vector<int>, double> Solve(const std::vector<std::vector<double>> &dist);
};

#endif