class ComponentMakeTemplate {

  static Map<String, List<String>> makeOptions = {

    //Enclosure
    "Enclosure Serial No. 1": ["RITTAL"],
    "Enclosure Serial No. 2": ["RITTAL"],

    // FAN BOX
    "Fan1": ["DELTA", "FANSTECH", "HICOOL"],
    "Fan2": ["DELTA", "FANSTECH", "HICOOL"],

    "NTC8 – Fan1 – 10K": ["HONEYWELL"],
    "NTC10 – Fan2 – 10K": ["HONEYWELL"],

    // MAGNETICS
    "L1": ["SALZER", "CSE"],
    "TR1": ["SALZER", "CSE"],
    "TR2": ["SALZER", "CSE"],
    "L2": ["SALZER", "CSE"],
    "TR3": ["SALZER", "CSE"],


    // SWITCHGEAR
    "CB01": ["ABB", "EATON", "LK", "SCHNEIDER", "C&S"],
    "CB02": ["ABB", "EATON", "LK", "SCHNEIDER", "C&S"],

    "K1": ["HIITIO", "GIGAVAC"],
    "K2": ["HIITIO", "GIGAVAC"],
    "K3": ["HONGFA", "GIGAVAC"],
    "K4": ["HIITIO", "GIGAVAC"],
    "K5": ["HIITIO", "GIGAVAC"],
    "K6": ["HONGFA", "GIGAVAC"],
    "K7": ["HIITIO", "GIGAVAC"],
    "K8": ["HIITIO", "GIGAVAC"],

    "SPD3 – AC SPD": ["CITEL", "PHOENIX"],
    "SPD4 – AC SPD AUX": ["CITEL", "PHOENIX"],
    "SPD1 – DC SPD": ["CITEL", "PHOENIX"],
    "SPD2 – DC SPD": ["CITEL", "PHOENIX"],

    "FU1": ["HOLLYLAND", "HIITIO", "LITTLEFUSE"],
    "FU2": ["HOLLYLAND", "HIITIO", "LITTLEFUSE"],
    "FU3": ["HOLLYLAND", "HIITIO", "LITTLEFUSE"],
    "FU4": ["HOLLYLAND", "HIITIO", "LITTLEFUSE"],

    "ETH2 – ETH SWITCH": ["PHOENIX"],

    "CBF": ["SCHNEIDER"],
    "CBF1": ["SCHNEIDER"],
    "CBF2": ["SCHNEIDER"],


    // SENSORS
    "HCTU1": ["LEM", "TAMURA", "SINOMAGS"],
    "HCTV1": ["LEM", "TAMURA", "SINOMAGS"],
    "HCTW1": ["LEM", "TAMURA", "SINOMAGS"],
    "HCTU2": ["LEM", "TAMURA", "SINOMAGS"],
    "HCTV2": ["LEM", "TAMURA", "SINOMAGS"],
    "HCTW2": ["LEM", "TAMURA", "SINOMAGS"],
    "HCTU3": ["LEM", "TAMURA", "SINOMAGS"],
    "HCTV3": ["LEM", "TAMURA", "SINOMAGS"],
    "HCTW3": ["LEM", "TAMURA", "SINOMAGS"],
    "HCTU4": ["LEM", "TAMURA", "SINOMAGS"],
    "HCTV4": ["LEM", "TAMURA", "SINOMAGS"],
    "HCTW4": ["LEM", "TAMURA", "SINOMAGS"],

    "HCTD1": ["LEM", "TAMURA", "SINOMAGS"],
    "HCTD2": ["LEM", "TAMURA", "SINOMAGS"],

    // NTC
    "NTC7 – P1 – 10K": ["HONEYWELL"],
    "NTC9 – P2 – 10K": ["HONEYWELL"],

    "A8-1 PT Sensing Board": ["Newen V", "Newen A"],
    "A8-2 PT Sensing Board": ["Newen V", "Newen A"],

    // RESISTORS
    "RA18 – 66KΩ 100W": ["KWK", "RAATRONICS"],
    "RA19 – 66KΩ 100W": ["KWK", "RAATRONICS"],
    "RA20 – 66KΩ 100W": ["KWK", "RAATRONICS"],

    "RA1 – 80E 500W": ["KWK", "RAATRONICS"],
    "RA2 – 80E 500W": ["KWK", "RAATRONICS"],

    "RA3 – 33KΩ 100W": ["KWK", "RAATRONICS"],
    "RA4 – 33KΩ 100W": ["KWK", "RAATRONICS"],
    "RA5 – 33KΩ 100W": ["KWK", "RAATRONICS"],
    "RA6 – 33KΩ 100W": ["KWK", "RAATRONICS"],

    "RA15 – 66KΩ 100W": ["KWK", "RAATRONICS"],
    "RA16 – 66KΩ 100W": ["KWK", "RAATRONICS"],
    "RA17 – 66KΩ 100W": ["KWK", "RAATRONICS"],


    // CAPACITORS
    "Cap Bank CF1": ["FARATRONIC", "TDK", "JIANGHAI"],
    "Cap Bank CF2": ["FARATRONIC", "TDK", "JIANGHAI"],
    "Cap Bank CF3": ["FARATRONIC", "TDK", "JIANGHAI"],
    "Cap Bank CF4": ["FARATRONIC", "TDK", "JIANGHAI"],
    "Cap Bank CF5": ["FARATRONIC", "TDK", "JIANGHAI"],
    "Cap Bank CF6": ["FARATRONIC", "TDK", "JIANGHAI"],


    // POWER SUPPLY
    "PS1 – 24V": ["MEANWELL"],
    "PS2 – 24V": ["MEANWELL"],
    "PS3 – 24V": ["MEANWELL"],
    "PS4 – 15V": ["MEANWELL"],
    "PS5 – 12V": ["MEANWELL"],
    "PS6 – 24V": ["MEANWELL"],
    "PS7 – 15V": ["MEANWELL"],
    "PS8 – +/-12V": ["MEANWELL"],
    "PS9 – 24V": ["MEANWELL"],
    "PS10 – 15V": ["MEANWELL"],
    "HMI": ["WEINTEK"],


    //PCB
    "A2-1 Interface Card": ['NEWEN-V','NEWEN-A'],
    "A3-1 Controller Card": ['NEWEN-V','NEWEN-A'],
    "A6-1 CB Card 1": ['NEWEN-V','NEWEN-A'],
    "A7-1 Gate Interlock Card": ['NEWEN-V','NEWEN-A'],
    "A7-2 Gate Interlock Card": ['NEWEN-V','NEWEN-A'],
    "A7-3 Gate Interlock Card": ['NEWEN-V','NEWEN-A'],
    "A12 AC Filter Card": ['NEWEN-V','NEWEN-A'],
    "A13-1 DC Filter": ['NEWEN-V','NEWEN-A'],
    "A1 Domain Controller": ['NEWEN-V','NEWEN-A'],
    "A2-2 Interface Card": ['NEWEN-V','NEWEN-A'],
    "A3-2 Controller Card": ['NEWEN-V','NEWEN-A'],
    "A3-3 Controller Card": ['NEWEN-V','NEWEN-A'],
    "A5 Power Supply ORing Card": ['NEWEN-V','NEWEN-A'],
    "A5-1 Power Supply ORing Card": ['NEWEN-V','NEWEN-A'],
    "A6-2 CB Card 2": ['NEWEN-V','NEWEN-A'],
    "A7-4 Gate Interlock Card": ['NEWEN-V','NEWEN-A'],
    "A7-5 Gate Interlock Card": ['NEWEN-V','NEWEN-A'],
    "A7-6 Gate Interlock Card": ['NEWEN-V','NEWEN-A'],
    "A10 SIM100": ['NEWEN-V','NEWEN-A'],
    "A11 Data Logger": ['NEWEN-V','NEWEN-A'],
    "A13-2 DC Filter": ['NEWEN-V','NEWEN-A'],

    // IGBT STACK ASSEMBLY
    "A4-1": ["NEWEN-V","NEWEN-A"],
    "A4-2": ["NEWEN-V","NEWEN-A"],
    "A4-3": ["NEWEN-V","NEWEN-A"],
    "A4-4": ["NEWEN-V","NEWEN-A"],
    "A4-5": ["NEWEN-V","NEWEN-A"],
    "A4-6": ["NEWEN-V","NEWEN-A"],
    "A4-7": ["NEWEN-V","NEWEN-A"],
    "A4-8": ["NEWEN-V","NEWEN-A"],
    "A4-9": ["NEWEN-V","NEWEN-A"],
    "A4-10": ["NEWEN-V","NEWEN-A"],
    "A4-11": ["NEWEN-V","NEWEN-A"],
    "A4-12": ["NEWEN-V","NEWEN-A"],

    "IGBT1": ["SEMIKRON"],
    "IGBT2": ["SEMIKRON"],
    "IGBT3": ["SEMIKRON"],
    "IGBT4": ["SEMIKRON"],
    "IGBT5": ["SEMIKRON"],
    "IGBT6": ["SEMIKRON"],
    "IGBT7": ["SEMIKRON"],
    "IGBT8": ["SEMIKRON"],
    "IGBT9": ["SEMIKRON"],
    "IGBT10": ["SEMIKRON"],
    "IGBT11": ["SEMIKRON"],
    "IGBT12": ["SEMIKRON"],
    "IGBT13": ["SEMIKRON"],
    "IGBT14": ["SEMIKRON"],
    "IGBT15": ["SEMIKRON"],
    "IGBT16": ["SEMIKRON"],
    "IGBT17": ["SEMIKRON"],
    "IGBT18": ["SEMIKRON"],
    "IGBT19": ["SEMIKRON"],
    "IGBT20": ["SEMIKRON"],
    "IGBT21": ["SEMIKRON"],
    "IGBT22": ["SEMIKRON"],
    "IGBT23": ["SEMIKRON"],
    "IGBT24": ["SEMIKRON"],

    "TS1 – 120°C": ["HONEYWELL"],
    "TS2 – 120°C": ["HONEYWELL"],
    "TS3 – 120°C": ["HONEYWELL"],
    "TS4 – 120°C": ["HONEYWELL"],
    "TS5 – 120°C": ["HONEYWELL"],
    "TS6 – 120°C": ["HONEYWELL"],
    "TS7 – 120°C": ["HONEYWELL"],
    "TS8 – 120°C": ["HONEYWELL"],
    "TS9 – 120°C": ["HONEYWELL"],
    "TS10 – 120°C": ["HONEYWELL"],
    "TS11 – 120°C": ["HONEYWELL"],
    "TS12 – 120°C": ["HONEYWELL"],

    "NTC1 – 10K": ["HONEYWELL"],
    "NTC2 – 10K": ["HONEYWELL"],
    "NTC3 – 10K": ["HONEYWELL"],
    "NTC4 – 10K": ["HONEYWELL"],
    "NTC5 – 10K": ["HONEYWELL"],
    "NTC6 – 10K": ["HONEYWELL"],

    "SKYPER1": ["SEMIKRON"],
    "SKYPER2": ["SEMIKRON"],
    "SKYPER3": ["SEMIKRON"],
    "SKYPER4": ["SEMIKRON"],

    "CD1-8": ["Faratronic", "Tdk"],
    "CD9-16": ["Faratronic", "Tdk"],
    "CD17-24": ["Faratronic", "Tdk"],
    "CD25-32": ["Faratronic", "Tdk"],
    "CD33-40": ["Faratronic", "Tdk"],
    "CD41-48": ["Faratronic", "Tdk"],

  };

}