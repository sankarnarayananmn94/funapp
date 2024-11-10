module.exports = async function (context, req) {
    try {
        context.log('Processing HTTP trigger function request.');
        
        const name = req.query.name || (req.body && req.body.name);
        if (!name) {
            throw new Error("Name parameter is missing.");
        }
        
        const responseMessage = `Hello, ${name}. This HTTP triggered function executed successfully.`;
        context.res = {
            status: 200,
            body: responseMessage
        };
    } catch (error) {
        context.log.error("Error processing request:", error.message);
        context.res = {
            status: 500,
            body: `Internal server error: ${error.message}`
        };
    }
};
