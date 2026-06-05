#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <iomanip>
#include <unistd.h>

using namespace std;

struct NetStats {
    long long rx_bytes;
    long long tx_bytes;
};

void printBanner() {
    const char* banner = R"(
  ____                 _____    _                     _                 
 / ___| _   _ ___     |_   _|__| | ___ _ __ ___   ___| |_ _ __ _   _    
 \___ \| | | / __|____  | |/ _ \ |/ _ \ '_ ` _ \ / _ \ __| '__| | | |   
  ___) | |_| \__ \____| | |  __/ |  __/ | | | | |  __/ |_| |  | |_| |   
 |____/ \__, |___/      |_|\___|_|\___|_| |_| |_|\___|\__|_|   \__, |   
        |___/                                                  |___/    
    )";
    cout << banner << endl;
}

void printMemoryTelemetry() {
    ifstream meminfo("/proc/meminfo");
    
    if (!meminfo.is_open()) {
        cerr << "FAILURE: Failed to read Memory Info." << endl;
        return;
    }

    string line;
    long long memTotal = 0, memFree = 0, buffers = 0, cached = 0;

    while (getline(meminfo, line)) {
        istringstream iss(line);
        string key;
        long long value;
        string unit;

        iss >> key >> value >> unit;

        if (key == "MemTotal:") memTotal = value;
        else if (key == "MemFree:") memFree = value;
        else if (key == "Buffers:") buffers = value;
        else if (key == "Cached:") cached = value;
    }
    meminfo.close();

    long long memUsed = memTotal - memFree - buffers - cached;

    double totalMB = memTotal / 1024.0;
    double usedMB = memUsed / 1024.0;
    double freeMB = memFree / 1024.0;
    double utilization = (usedMB / totalMB) * 100.0;

    cout << "==========MEMORY==========" << endl;
    cout << fixed << setprecision(2);
    cout << "RAM Total  : " << totalMB << " MB" << endl;
    cout << "RAM Used   : " << usedMB << " MB (" << utilization << "%)" << endl;
    cout << "RAM Free   : " << freeMB << " MB" << endl;
    cout << "==========================" << endl;
}

NetStats getNetworkStats() {
    ifstream netdev("/proc/net/dev");
    string line;
    NetStats stats = {0, 0};

    if (!netdev.is_open()) return stats;

    getline(netdev, line);
    getline(netdev, line);

    while (getline(netdev, line)) {
        if (line.find("lo:") != string::npos) continue;

        istringstream iss(line);
        string interfaceName;
        long long col[17] = {};

        iss >> interfaceName;
        for (int i = 0; i < 16; ++i) iss >> col[i];

        stats.rx_bytes += col[0];  // rx_bytes is column 1 (index 0)
        stats.tx_bytes += col[8];  // tx_bytes is column 9 (index 8)
    }
    return stats;
}

int main() {
    NetStats prevNet = getNetworkStats();

    while (true) {
        cout << "\033[2J\033[1;1H"; // Clear screen, cursor to top
        printBanner();
        printMemoryTelemetry();

        NetStats currNet = getNetworkStats();
        double rxSpeedMB = (currNet.rx_bytes - prevNet.rx_bytes) / 1048576.0;
        double txSpeedMB = (currNet.tx_bytes - prevNet.tx_bytes) / 1048576.0;

        cout << "=========NETWORK=========" << endl;
        cout << fixed << setprecision(2);
        cout << "Download Speed : " << rxSpeedMB << " MB/s" << endl;
        cout << "Upload Speed   : " << txSpeedMB << " MB/s" << endl;
        cout << "=========================" << endl;
        cout.flush();

        prevNet = currNet;
        sleep(3);
    }
    return 0;
}
