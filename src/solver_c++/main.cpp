#include "utils/parser.hpp"
#include "utils/solver.hpp"

#include <iostream>
#include <vector>
#include <iomanip>

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        std::cerr << "Usage: " << argv[0] << " <tsp_file_path>" << std::endl;
        return 1;
    }

    std::string filepath = argv[1];
    std::vector<std::vector<double>> distMatrix = PARSER::ParseProblem(filepath);

    if (distMatrix.empty())
    {
        std::cerr << "Failed to parse TSP file or file is empty." << std::endl;
        return 1;
    }

    auto [tour, cost] = SOLVER::Solve(distMatrix);

    std::cout << "Optimal TSP tour: ";
    for (int city : tour)
        std::cout << city << " ";
    std::cout << "\nTotal cost: " << cost << std::endl;

    return 0;
}
