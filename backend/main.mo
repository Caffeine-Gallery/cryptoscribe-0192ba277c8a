import Text "mo:base/Text";

import Time "mo:base/Time";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";

actor {
    // Post type definition
    public type Post = {
        title: Text;
        body: Text;
        author: Text;
        timestamp: Time.Time;
    };

    // Stable variable to store posts
    private stable var posts : [Post] = [];
    private let postsBuffer = Buffer.Buffer<Post>(0);

    // Initialize buffer with stable posts
    private func initBuffer() {
        for (post in posts.vals()) {
            postsBuffer.add(post);
        };
    };

    // Called after upgrade
    system func postupgrade() {
        initBuffer();
    };

    // Called before upgrade to save state
    system func preupgrade() {
        posts := Buffer.toArray(postsBuffer);
    };

    // Add a new post
    public func createPost(title: Text, body: Text, author: Text) : async () {
        let newPost : Post = {
            title = title;
            body = body;
            author = author;
            timestamp = Time.now();
        };
        postsBuffer.add(newPost);
    };

    // Get all posts in reverse chronological order
    public query func getPosts() : async [Post] {
        let posts = Buffer.toArray(postsBuffer);
        Array.tabulate<Post>(posts.size(), func (i) = posts[posts.size() - 1 - i])
    };
};
