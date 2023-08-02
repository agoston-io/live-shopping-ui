export default () => {
    return (v) => {
        if (!v) return "unknown";
        const date = new Date(v.toString());
        const currentDate = new Date();
        const elapsed_ms = currentDate - date;
        if (elapsed_ms <= 0) {
            return '-1'
        }
        // Human readable
        var d, h, m, s;
        s = Math.floor(elapsed_ms / 1000);
        m = Math.floor(s / 60);
        if (m === 0) {
            if (s === 1) {
                return s + " second ago";
            } else {
                return s + " seconds ago";
            }
        }
        s = s % 60;
        h = Math.floor(m / 60);
        if (h === 0) {
            if (m === 1) {
                return m + " minute ago";
            } else {
                return m + " minutes ago";
            }
        }
        m = m % 60;
        d = Math.floor(h / 24);
        if (d === 0) {
            if (h === 1) {
                return h + " hour ago";
            } else {
                return h + " hours ago";
            }
        }
        h = h % 24;
        return new Date(v.toString()).toDateString();
    }
};