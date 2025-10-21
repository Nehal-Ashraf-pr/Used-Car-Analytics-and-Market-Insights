import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

# Load cleaned dataset
df = pd.read_csv("Cars_data.csv")
df.rename(columns={'Price(?)': 'Price'}, inplace=True)


print(df.shape)
print(df.columns)
df.head()

df.describe(include='all')
df.info()

sns.histplot(df['Price'], bins=30, kde=True)
plt.title('Cars vs Price')
plt.xlabel('Price in lakhs')
plt.ylabel("No. of cars")

# Example 1: Boxplot — Price by Fuel Type
plt.figure(figsize=(10,6))
sns.boxplot(x='fuel', y='Price', data=df, palette='viridis', showfliers=False)
plt.title('Price Distribution by Fuel Type', fontsize=14, weight='bold')
plt.xlabel('Fuel Type'); plt.ylabel('Price (₹)')
plt.show()

# Example 2: Bar Chart — Average Price by Brand
plt.figure(figsize=(10,5))
top_brands = df.groupby('Brand')['Price'].mean().sort_values(ascending=False).head(10)
sns.barplot(x=top_brands.index, y=top_brands.values, palette='Reds_r')
plt.title('Top 10 Brands by Average Price')
plt.xlabel('Brand')
plt.ylabel('Average Price (₹)')
plt.xticks(rotation=45)
plt.show()

# Example 3: Scatterplot — Price vs KM Driven
plt.figure(figsize=(8,5))
sns.scatterplot(x='Km_driven', y='Price', hue='fuel', data=df)
plt.title('Price vs. KM Driven by Fuel Type')
plt.xlabel('Kilometers Driven')
plt.ylabel('Price (₹)')
plt.show()

# --- 4. Price by Spinny Category ---
plt.figure(figsize=(8,5))
sns.boxplot(x='spiny_category', y='Price', data=df, palette='coolwarm', showfliers=False)
plt.title('Price Distribution by Spinny Category', fontsize=14, weight='bold')
plt.xlabel('Spinny Category'); plt.ylabel('Price (₹)')
plt.show()

features = ['Km_driven', 'age_years', 'fuel', 'transmission', 'spiny_category', 'city']
target = 'Price'

df = df[features + [target]]
df = pd.get_dummies(df, drop_first=True)  # One-hot encode categoricals


plt.figure(figsize=(10,6))
sns.heatmap(df.corr(numeric_only=True), annot=True, cmap='coolwarm')
plt.title("Feature Correlation Matrix")
plt.show()