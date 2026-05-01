String[][] globalPropertyVars = {
  {"ESA", "2"},
  {"E1E2A", "1"},
  {"ECSA", "-0.9"},
  {"E1C2A", "2.8"},
  {"E2C1A", "2.8"},
};
float parseExpression(String n) {
  try {
    return Float.valueOf(n);
 
  }catch (NumberFormatException e) {
    for (int i = 0; i < globalPropertyVars.length; i++) {
      if (n.equals(globalPropertyVars[i][0])) {
        return Float.valueOf(globalPropertyVars[i][1]);
      }
    }
    throw new RuntimeException("Unknown variable: " + n);
  }
}

// Particle names
final int WATER  = 0;
final int C1     = 1;
final int C2     = 2;
final int E1     = 3;
final int E2     = 4;

// Particle props
final int COLLISIONS = 0;
final int REPULSIONS = 1;
final int FALLOFF = 2;

// Map element names to IDs
HashMap<String, Integer> elementMap = new HashMap<String, Integer>();
HashMap<String, Integer> propMap    = new HashMap<String, Integer>();

// Store properties: [type1][type2][property] = value
float[][][] properties;
void particleTypesSetup() {
  elementMap.put("WATER", WATER);
  elementMap.put("C1", C1);
  elementMap.put("C2", C2);
  
  elementMap.put("E1", E1);
  elementMap.put("E2", E2);
  
  propMap.put("collision", COLLISIONS);
  propMap.put("repulsion", REPULSIONS);
  propMap.put("falloff", FALLOFF);
  propMap.put("reaction", -1); // placeholder

  int n = elementMap.size();
  int p = propMap.size();
  properties = new float[n][n][p];
  loadProperties("particles.txt");
}
void loadProperties(String filename) {
  String[] lines = loadStrings(filename);
  for (String line : lines) {
    if (line.trim().length() == 0 || line.startsWith("/")) continue; // skip blanks/comments
    String[] parts = splitTokens(line, " ");
    if (parts.length < 4) continue;

    // Expand groups for type1 and type2
    String[] group1 = expandGroup(parts[0]);
    String[] group2 = expandGroup(parts[1]);

    String propName = parts[2];
    int property = propMap.get(propName);

    if (property >= 0) {
      float value = parseExpression(parts[3]);

      // For every combination in group1 * group2
      for (String g1 : group1) {
        for (String g2 : group2) {
          int type1 = elementMap.get(g1);
          int type2 = elementMap.get(g2);
          println(property);
          properties[type1][type2][property] = value;
          properties[type2][type1][property] = value;
        }
      }
    }
  }
}

// expand {E1,E2,C1} → ["E1","E2","C1"]
// expand plain "E1" → ["E1"]
String[] expandGroup(String token) {
  token = token.trim();
  if (token.startsWith("{") && token.endsWith("}")) {
    token = token.substring(1, token.length()-1);
    return splitTokens(token, ",");
  } else {
    return new String[] { token };
  }
}


float getParticleProperty(int type1, int type2, int property) {
  return properties[type1][type2][property];
}

int getParticleColor(int type) {
  switch (type) {
  case WATER:
    return color(0, 0, 255);
  case C1:
    return color(0, 255, 0);
  case C2:
    return color(0, 255, 255);
  case E1:
    return color(200, 100, 0);
  case E2:
    return color(255, 0, 0);
  default:
    return color(255);
  }
}
boolean isTransparent(int type) {
  switch (type) {
  case WATER:
    return false;
  case C1:
    return false;
  case C2:
    return false;
  case E1:
    return false;
  case E2:
    return false;
  default:
    return false;
  }
}
