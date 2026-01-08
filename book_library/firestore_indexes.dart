// Firestore composite index configuration
// This file documents the indexes needed for the app
// Create these indexes in Firebase Console or using Firebase CLI

/*
Collection: books

Index 1: For fetching user's books ordered by creation date
- Field: userId (Ascending)
- Field: createdAt (Descending)

Index 2: For fetching user's books by status
- Field: userId (Ascending)
- Field: status (Ascending)
- Field: createdAt (Descending)

To create indexes via Firebase Console:
1. Go to Firebase Console -> Firestore Database -> Indexes
2. Click "Add Index"
3. Select collection "books"
4. Add the fields as specified above
5. Click "Create Index"

Alternative: Run `firebase deploy --only firestore:indexes` with this firestore.indexes.json:

{
  "indexes": [
    {
      "collectionGroup": "books",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "userId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "books",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "userId", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    }
  ]
}
*/
