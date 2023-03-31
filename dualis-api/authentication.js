import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
import { getUser, getSecretary } from './database.js';

dotenv.config();

const jwtKey = process.env.JWT_KEY;

/**
 * Middleware to verify the token
 * Sets the secretaryId in the request object
 */
const verifyToken = async (req, res, next) => {
    const token = req.headers.authorization;
    if (!token) {
        res.status(401).send('No token provided');
        return;
    }
    const secretaryId = await jwt.verify(token, jwtKey, async (err, decoded) => {
        if (err || !decoded.Email || !decoded.UserID) {
            res.status(403).send('Invalid token');
            return;
        }
        const user = await getUser(decoded.Email, decoded.UserID);
        if (!user || user.Role != 'Secretary') {
            res.status(403).send('Invalid token');
            return;
        }
        const sectretary = await getSecretary(user.UserID);
        if (!sectretary) {
            res.status(403).send('Invalid token');
            return;
        }
        return sectretary.SecretaryID;
    });
    if (!secretaryId) {
        return;
    }
    req.secretaryId = secretaryId;
    next();
}

export { verifyToken };
