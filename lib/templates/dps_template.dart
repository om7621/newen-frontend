class DPSTemplate {
  static Map<String, List<String>> sections = {
    "Enclosure": ["Enclosure Serial No / Rev No"],
    "Fan Box": ["Pan1", "NTC8 – Fan1 – 10K"],
    "Magnetics": ["L1 (480uH/633A) - 1", "L1 (480uH/633A) - 2", "TV"],
    "Switchgears": [
      "T1A", "T1B", "T2A", "T2B", "T3A", "T6A", "T6B", "T3", "T4", "T5", "T7", "T8",
      "FU1 (1500VDC)", "FU2 (1500VDC)", "FU4 (1250A 1500VDC)", "FU8 (1250A 1500VDC)",
      "ETH2 – ETH SWITCH", "QF1"
    ],
    "Sensors": ["HALL1", "HALL2", "HALL3", "HALL4", "HALL5"],
    "Resistors": [
      "RS1 (HEATER)", "HU1 (HUMIDISTAT)",
      "KT1", "KT2", "KT3", "KT4", "KT5", "KT6", "KT7", "KT8", "KT9",
      "R1-R2 100E/150W", "R3-R14 7.5K/60W", "R15-10E/2W", "R16-100E/150W", "R17-100E/150W"
    ],
    "PCB": [
      "Controller (NI Board)", "DPS A1 - Interface Board",
      "DPS A2 - Power Supply Board - 24VDC", "DPS A3 - Power Supply Board - 15VDC",
      "DPS A3-1 Power Supply Board - 15VDC", "DPS IGBT Driver Board A4",
      "DPS IGBT Driver Board A5", "DPS IGBT Driver Board A6", "DPS IGBT Driver Board A7",
      "DPS A12 Fan Controller Board", "DPS A13 Signal Detection and Power Transfer Board",
      "DPS A14 Contactor Power Board"
    ],
    "Filter": ["DPS Filter Board FL1", "DPS Filter Board FL2", "DPS Filter Board FL3", "DPS Filter Board FL4", "FILTER-5"],
    "Capacitor": ["C1-C12", "C13-C24"],
    "Stack-1": [
      "DPS IGBT Adaptor Board A8A-S1", "DPS IGBT Adaptor Board A8B-S1", "DPS IGBT Adaptor Board A8C-S1",
      "(IGBT) Q1-A-S1", "(IGBT) Q1-B-S1", "(IGBT) Q1-C-S1", "SKYPER 1-S1"
    ],
    "Stack-2": [
      "DPS IGBT Adaptor Board A9A-S2", "DPS IGBT Adaptor Board A9B-S2", "DPS IGBT Adaptor Board A9C-S2",
      "(IGBT) Q2-A-S2", "(IGBT) Q2-B-S2", "(IGBT) Q2-C-S2", "SKYPER 2-S2"
    ],
    "Stack-3": [
      "DPS IGBT Adaptor Board A10A-S3", "DPS IGBT Adaptor Board A10B-S3", "DPS IGBT Adaptor Board A10C-S3",
      "(IGBT) Q3-A-S3", "(IGBT) Q3-B-S3", "(IGBT) Q3-C-S3", "SKYPER 3-S3"
    ],
    "Stack-4": [
      "DPS IGBT Adaptor Board A11A-S4", "DPS IGBT Adaptor Board A11B-S4", "DPS IGBT Adaptor Board A11C-S4",
      "(IGBT) Q4-A-S4", "(IGBT) Q4-B-S4", "(IGBT) Q4-C-S4", "SKYPER 4-S4"
    ],
  };
}
