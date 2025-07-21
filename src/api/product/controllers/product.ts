/**
 * product controller
 */

import { Core, factories } from '@strapi/strapi';

export default factories.createCoreController(
  'api::product.product',
  ({ strapi }: { strapi: Core.Strapi }) => ({
    async findOne(ctx) {
      const { id } = ctx.params;

      const sanitizedQueryParams = await this.sanitizeQuery(ctx);

      const product = await strapi.documents('api::product.product').findMany({
        ...sanitizedQueryParams,
        filters: { slug: id },
      });

      const sanitizedEntity = await this.sanitizeOutput(product[0], ctx);

      return this.transformResponse(sanitizedEntity);
    },
  })
);